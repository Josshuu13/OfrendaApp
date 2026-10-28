import SwiftUI

struct InicioView: View {
    let naranja = Color(hex: 0xF6A63C)

    var body: some View {
        ZStack {
            Color(hex: 0x1A0F1F).ignoresSafeArea()

            VStack(spacing: 20) {
                Text("DÍA DE MUERTOS")
                    .font(.footnote.bold()).tracking(3)
                    .foregroundStyle(Color(hex: 0xD8B98F))
                Text("Bienvenido a la Alumbrada de Mixquic")
                    .font(.system(size: 36, weight: .bold, design: .serif))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)

                Spacer()
                OfrendaDibujo(color: naranja)
                Spacer()

                Text("Recorre el panteón y descubre el significado de cada elemento.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.75))

                NavigationLink {
                    OfrendaView()
                } label: {
                    Label("Empezar", systemImage: "arrow.right")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(naranja, in: Capsule())
                        .foregroundStyle(Color(hex: 0x2A1606))
                }
            }
            .padding(32)
        }
    }
}

// Dibujo del altar con velas que parpadean
struct OfrendaDibujo: View {
    var color: Color

    var body: some View {
        ZStack {
            Circle().fill(color.opacity(0.10)).frame(width: 256)
            Circle().fill(color.opacity(0.12)).frame(width: 160)

            TimelineView(.animation) { tiempo in
                let t = tiempo.date.timeIntervalSinceReferenceDate
                Canvas { ctx, _ in
                    ctx.fill(Path(roundedRect: CGRect(x: 40, y: 250, width: 180, height: 22),