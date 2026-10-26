//
//  InicioView.swift
//  OfrendaApp
//
//  Created by Josue Cardoso on 20/10/26.
//
import SwiftUI

struct InicioView: View {
    // Variable para controlar la animación del resplandor
    @State private var latido = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            // Luz de fondo central
            RadialGradient(
                gradient: Gradient(colors: [Color.orange.opacity(0.4), Color.black]),
                center: .center,
                startRadius: 50,
                endRadius: 350
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
               
                
                // Textos
                VStack(spacing: 12) {
                    Text("La Alumbrada")
                        .font(.system(size: 46, weight: .heavy, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(colors: [.orange, .yellow], startPoint: .leading, endPoint: .trailing)
                        )
                        .shadow(color: .orange.opacity(0.6), radius: 10, x: 0, y: 0)
                    
                    Text("SAN ANDRÉS MIXQUIC")
                        .font(.title3.bold())
                        .foregroundColor(.white.opacity(0.9))
                        .tracking(4)
                }
                
                Spacer()
                
                // Botón
                NavigationLink(destination: OfrendaView()) {
                    HStack {
                        Text("Entrar a la ofrenda")
                            .font(.title3.bold())
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 16)
                    .padding(.horizontal, 32)
                    .background(Color.orange)
                    .clipShape(Capsule())
                    .shadow(color: .orange.opacity(0.7), radius: 12, x: 0, y: 6)
                }
                .padding(.bottom, 50)
            }
        }
    }
}

#Preview {
    NavigationStack {
        InicioView()
    }
}
