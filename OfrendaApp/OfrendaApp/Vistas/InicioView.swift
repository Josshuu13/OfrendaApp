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
                    ctx.fill(Path(roundedRect: CGRect(x: 40, y: 250, width: 180, height: 22), cornerRadius: 4), with: .color(Color(hex: 0x6B2D6B)))
                    ctx.fill(Path(roundedRect: CGRect(x: 62, y: 226, width: 136, height: 24), cornerRadius: 4), with: .color(Color(hex: 0x7E3A7E)))
                    ctx.fill(Path(roundedRect: CGRect(x: 84, y: 202, width: 92, height: 24), cornerRadius: 4), with: .color(Color(hex: 0x94489A)))

                    let cera = GraphicsContext.Shading.color(Color(hex: 0xF4ECDC))
                    ctx.fill(Path(roundedRect: CGRect(x: 84, y: 148, width: 18, height: 54), cornerRadius: 3), with: cera)
                    ctx.fill(Path(roundedRect: CGRect(x: 121, y: 128, width: 18, height: 74), cornerRadius: 3), with: cera)
                    ctx.fill(Path(roundedRect: CGRect(x: 158, y: 148, width: 18, height: 54), cornerRadius: 3), with: cera)

                    ctx.drawLayer { capa in
                        capa.addFilter(.shadow(color: color, radius: 10))
                        capa.fill(llama(x: 93,  base: 146, alto: 24 * (1 + 0.10 * sin(t * 6))), with: .color(color))
                        capa.fill(llama(x: 130, base: 126, alto: 28 * (1 + 0.10 * sin(t * 7 + 1))), with: .color(color))
                        capa.fill(llama(x: 167, base: 146, alto: 24 * (1 + 0.10 * sin(t * 5 + 2))), with: .color(color))
                    }

                    for (x, y, r, c) in [(52.0, 244.0, 9.0, 0xF28A12), (66, 240, 8, 0xF6A63C),
                                         (208, 244, 9, 0xF28A12), (194, 240, 8, 0xF6A63C)] {
                        ctx.fill(Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2)),
                                 with: .color(Color(hex: UInt(c))))
                    }
                }
            }
        }
        .frame(width: 260, height: 300)
        .accessibilityHidden(true)
    }

    func llama(x: CGFloat, base: CGFloat, alto: CGFloat) -> Path {
        let ancho = alto * 0.25
        var p = Path()
        p.move(to: CGPoint(x: x, y: base))
        p.addCurve(to: CGPoint(x: x, y: base - alto),
                   control1: CGPoint(x: x - ancho, y: base - alto * 0.33),
                   control2: CGPoint(x: x - ancho * 0.67, y: base - alto * 0.67))
        p.addCurve(to: CGPoint(x: x, y: base),
                   control1: CGPoint(x: x + ancho * 0.67, y: base - alto * 0.67),
                   control2: CGPoint(x: x + ancho, y: base - alto * 0.33))
        return p
    }
}

#Preview {
    NavigationStack { InicioView() }
}
