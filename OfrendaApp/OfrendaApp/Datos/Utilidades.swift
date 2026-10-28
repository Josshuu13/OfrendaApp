//
//  Datos.swift
//  OfrendaApp
//
//  Created by Josue Cardoso on 26/10/26.
//

import SwiftUI

// Colores en hexadecimal, ej. Color(hex: 0xF6A63C)
extension Color {
    init(hex: UInt) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255)
    }
}
