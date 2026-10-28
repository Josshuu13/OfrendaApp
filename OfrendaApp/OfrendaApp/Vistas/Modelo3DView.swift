import SwiftUI
import RealityKit

struct Modelo3DView: View {
    let archivo: String                 // nombre del .usdz sin extensión
    var entidad: Entity? = nil          // pieza ya cargada (copiada del panteón); tiene prioridad sobre el archivo
    var icono = "cube.transparent"      // se muestra si no existe el archivo
    var avisoSiFalta = false            // muestra texto de aviso si no existe
    var ponerDePie = false              // true si el modelo sale acostado
    var margen: Float = 1.0             // 1 = cabe justo; menor = más cerca al inicio
    var mostrarControles = true         // botones de girar, mover y zoom
    var alTocar: ((Entity) -> Void)? = nil

    enum Modo { case girar, mover }

    @State private var pivote = Entity()
    @State private var camara = PerspectiveCamera()
    @State private var distanciaBase: Float = 2
    @State private var noEncontrado = false
    @State private var modo: Modo = .girar

    @State private var giro: Float = 0
    @State private var giroInicial: Float = 0
    @State private var desplazamiento = SIMD2<Float>(0, 0)
    @State private var desplazamientoInicial = SIMD2<Float>(0, 0)
    @State private var zoom: Float = 1
    @State private var zoomInicial: Float = 1

    let zoomMinimo: Float = 0.7
    let zoomMaximo: Float = 8
    let direccionCamara = simd_normalize(SIMD3<Float>(0, 0.3, 1))   // desde el frente y un poco arriba

    var body: some View {
        GeometryReader { geo in
            ZStack {
                RealityView { content in
                    // Usa la pieza copiada del panteón; si no hay, busca el archivo .usdz
                    let modelo: Entity
                    if let entidad {
                        modelo = entidad
                    } else if let cargado = try? await Entity(named: archivo) {
                        modelo = cargado
                    } else {
                        noEncontrado = true
                        return
                    }

                    // 1. Corregir orientación si viene acostado
                    if ponerDePie {
                        modelo.orientation = simd_quatf(angle: -.pi / 2, axis: [1, 0, 0])
                    }

                    // 2. Centrar y normalizar tamaño (cabe en una esfera de radio 0.5)
                    let caja = modelo.visualBounds(relativeTo: nil)
                    let radio = simd_length(caja.extents) / 2
                    guard radio > 0 else { return }
                    let escala = 0.5 / radio
                    modelo.scale *= escala
                    modelo.position = -caja.center * escala

                    // 3. Permitir toques y reproducir animación si tiene
                    modelo.generateCollisionShapes(recursive: true)
                    modelo.components.set(InputTargetComponent())
                    if let animacion = modelo.availableAnimations.first {
                        modelo.playAnimation(animacion.repeat())
                    }

                    pivote.addChild(modelo)
                    content.add(pivote)

                    // 4. Cámara a la distancia exacta para que quepa en la pantalla
                    let aspecto = Float(geo.size.width / max(geo.size.height, 1))
                    let fovY: Float = 50
                    let medioY = fovY * .pi / 360
                    let medioX = atan(tan(medioY) * aspecto)
                    distanciaBase = 0.5 / sin(min(medioX, medioY)) * margen

                    camara.camera.fieldOfViewInDegrees = fovY
                    camara.camera.near = 0.005
                    colocarCamara()
                    content.add(camara)

                    // 5. Luz
                    let luz = DirectionalLight()
                    luz.light.intensity = 3000
                    luz.look(at: .zero, from: [1, 2, 2], relativeTo: nil)
                    content.add(luz)

                    content.camera = .virtual
                }
                // Un dedo: girar o mover según el modo
                .gesture(
                    DragGesture(minimumDistance: 5)
                        .onChanged { valor in
                            switch modo {
                            case .girar:
                                giro = giroInicial + Float(valor.translation.width) * 0.01
                                pivote.orientation = simd_quatf(angle: giro, axis: [0, 1, 0])
                            case .mover:
                                // Más cerca = se mueve más despacio, como en una foto ampliada
                                let factor = distanciaBase / zoom * 0.0015
                                desplazamiento = desplazamientoInicial +
                                    SIMD2<Float>(Float(valor.translation.width), Float(-valor.translation.height)) * factor
                                pivote.position = [desplazamiento.x, desplazamiento.y, 0]
                            }
                        }
                        .onEnded { _ in
                            giroInicial = giro
                            desplazamientoInicial = desplazamiento
                        }
                )
                // Dos dedos: acercar o alejar la cámara
                .simultaneousGesture(
                    MagnifyGesture()
                        .onChanged { valor in
                            zoom = min(max(zoomInicial * Float(valor.magnification), zoomMinimo), zoomMaximo)
                            colocarCamara()
                        }
                        .onEnded { _ in zoomInicial = zoom }
                )
                // Tocar un objeto
                .simultaneousGesture(
                    SpatialTapGesture().targetedToAnyEntity().onEnded { valor in
                        alTocar?(valor.entity)
                    }
                )

                // Si no existe el archivo
                if noEncontrado {
                    VStack(spacing: 12) {
                        Image(systemName: icono)
                            .font(.system(size: 80))
                            .foregroundStyle(Color(hex: 0xF6A63C))
                        if avisoSiFalta {
                            Text("No se encontró \(archivo).usdz en el proyecto")
                                .font(.callout)
                                .foregroundStyle(.white)
                        }
                    }
                }
            }
            // Botones de control a la derecha
            .overlay(alignment: .trailing) {
                if mostrarControles && !noEncontrado {
                    VStack(spacing: 10) {
                        boton("arrow.triangle.2.circlepath", activo: modo == .girar, etiqueta: "Girar") { modo = .girar }
                        boton("hand.draw", activo: modo == .mover, etiqueta: "Mover") { modo = .mover }
                        Divider().frame(width: 28).overlay(.white.opacity(0.3))
                        boton("plus.magnifyingglass", etiqueta: "Acercar") { cambiarZoom(por: 1.5) }
                        boton("minus.magnifyingglass", etiqueta: "Alejar") { cambiarZoom(por: 1 / 1.5) }
                        boton("arrow.counterclockwise", etiqueta: "Restablecer vista") { restablecer() }
                    }
                    .padding(8)
                    .background(.black.opacity(0.35), in: Capsule())
                    .padding(.trailing, 12)
                }
            }
        }
    }

    // MARK: - Funciones de cámara

    func colocarCamara() {
        camara.look(at: .zero, from: direccionCamara * (distanciaBase / zoom), relativeTo: nil)
    }

    func cambiarZoom(por factor: Float) {
        zoom = min(max(zoom * factor, zoomMinimo), zoomMaximo)
        zoomInicial = zoom
        colocarCamara()
    }

    func restablecer() {
        giro = 0; giroInicial = 0
        desplazamiento = .zero; desplazamientoInicial = .zero
        zoom = 1; zoomInicial = 1
        modo = .girar
        pivote.orientation = simd_quatf(angle: 0, axis: [0, 1, 0])
        pivote.position = .zero
        colocarCamara()
    }

    func boton(_ simbolo: String, activo: Bool = false, etiqueta: String,
               accion: @escaping () -> Void) -> some View {
        Button(action: accion) {
            Image(systemName: simbolo)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 44, height: 44)
                .foregroundStyle(activo ? Color(hex: 0x2A1606) : .white)
                .background(activo ? Color(hex: 0xF6A63C) : .clear, in: Circle())
        }
        .accessibilityLabel(etiqueta)
    }
}
