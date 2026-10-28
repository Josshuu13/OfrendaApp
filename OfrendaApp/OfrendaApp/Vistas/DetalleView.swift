import SwiftUI
import RealityKit

struct DetalleView: View {
    let elemento: Elemento
    var pieza: Entity? = nil    // copia de la pieza tocada en el panteón

    var body: some View {
        ZStack {
            Color(hex: 0x1A0F1F).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 1º la pieza del panteón, 2º su archivo propio, 3º el ícono
                    ZStack {
                        RoundedRectangle(cornerRadius: 24).fill(.white.opacity(0.06))
                        Modelo3DView(archivo: elemento.modelo,
                                     entidad: pieza,
                                     icono: elemento.icono,
                                     mostrarControles: false)
                    }
                    .frame(height: 320)
                    .clipShape(RoundedRectangle(cornerRadius: 24))

                    Text(elemento.nombre)
                        .font(.system(size: 32, weight: .bold, design: .serif))
                        .foregroundStyle(.white)

                    Text(elemento.significado)
                        .foregroundStyle(.white.opacity(0.8))
                        .lineSpacing(4)
                }
                .padding(24)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    NavigationStack { DetalleView(elemento: elementos[0]) }
}
