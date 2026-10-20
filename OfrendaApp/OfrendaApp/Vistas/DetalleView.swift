//
//  DetalleView.swift
//  OfrendaApp
//
//  Created by Josue Cardoso on 20/10/26.
//

import SwiftUI

struct DetalleView: View {
    let elemento: Elemento
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(elemento.nombre).font(.largeTitle.bold())
            Text(elemento.nivel).foregroundStyle(.secondary)
            Text(elemento.significado)
            Spacer()
        }
        .padding()
    }
}
