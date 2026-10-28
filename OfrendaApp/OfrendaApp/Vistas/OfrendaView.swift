import SwiftUI
import RealityKit

struct OfrendaView: View {
    @State private var seleccionado: Elemento?
    @State private var pieza: Entity?
    @State private var tocado: String?

    var body: some View {
        ZStack {
            Color(hex: 0x1A0F1F).ignoresSafeArea()

            Modelo3DView(
                archivo: "Prueba2",       // ← nombre de tu modelo
                icono: "exclamationmark.triangle",
                avisoSiFalta: true,
                ponerDePie: false,       // cámbialo a true si sale acostado
                margen: 0.6              // 0.8 = más grande, 1.2 = más pequeño
            ) { entidad in
                tocado = entidad.name    // prueba: muestra qué tocaste

                // Si el nombre coincide con un elemento, abre su detalle
                var e: Entity? = entidad
                while let actual = e {
                    if let elemento = elementos.first(where: { $0.id == actual.name }) {
                        pieza = actual.clone(recursive: true)
                        seleccionado = elemento
                        return
                    }
                    e = actual.parent
                }
            }
            .ignoresSafeArea(edges: .bottom)

            VStack {
                if let tocado {
                    Text("Tocaste: \(tocado)")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(.black.opacity(0.4), in: Capsule())
                        .padding(.top, 12)
                }
                Spacer()
                HStack(spacing: 10) {
                    Image(systemName: "hand.tap.fill")
                        .foregroundStyle(Color(hex: 0xF6A63C))
                    Text("Selecciona cada elemento para que puedas ver su función")
                        .font(.callout)
                        .foregroundStyle(.white.opacity(0.85))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(.white.opacity(0.08), in: Capsule())
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .navigationTitle("Panteón de Mixquic")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .navigationDestination(item: $seleccionado) { elemento in
            DetalleView(elemento: elemento, pieza: pieza)
        }
    }
}

#Preview {
    NavigationStack { OfrendaView() }
}
