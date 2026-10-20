//
//  Elementos.swift
//  OfrendaApp
//
//  Created by Josue Cardoso on 20/10/26.
//

struct Elemento: Identifiable, Hashable {
    let id: String
    let nombre: String
    let modelo: String
    let nivel: String
    let significado: String
}

let elementos: [Elemento] = [
    Elemento(id: "Calaveritas", nombre: "Calaveritas", modelo: "calaveritas",
             nivel: "Primer nivel",
             significado: "Recuerdan la presencia constante de la muerte."),
    Elemento(id: "Agua", nombre: "Agua", modelo: "agua",
             nivel: "Primer nivel",
             significado: "Purifica el alma y calma la sed del difunto.")
]
