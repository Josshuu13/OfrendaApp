//
//  InicioView.swift
//  OfrendaApp
//
//  Created by Josue Cardoso on 20/10/26.
//

import SwiftUI

struct InicioView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Ofrenda de Día de Muertos").font(.largeTitle.bold())
            NavigationLink("Entrar a la ofrenda") { OfrendaView() }
                .buttonStyle(.borderedProminent)
        }
    }
}
