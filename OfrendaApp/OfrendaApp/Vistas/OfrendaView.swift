//
//  OfrendaView.swift
//  OfrendaApp
//
//  Created by Josue Cardoso on 20/10/26.
//

import SwiftUI

struct OfrendaView: View {
    var body: some View {
        List(elementos) { e in
            NavigationLink(e.nombre, value: e)
        }
        .navigationTitle("Mi ofrenda")
        .navigationDestination(for: Elemento.self) { e in
            DetalleView(elemento: e)
        }
    }
}
