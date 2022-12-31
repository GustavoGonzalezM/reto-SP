//
//  Offices.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 30/12/22.
//

import Foundation

struct Sophos: Codable {
    let offices: [Office]
    
    enum CodingKeys: String, CodingKey {
        case offices = "Items"
    }
}

struct Office: Codable {
    let ciudad: String
    let longitud: String
    let idOficina: Int
    let latitud: String
    let nombre: String

    enum CodingKeys: String, CodingKey {
        case ciudad = "Ciudad"
        case longitud = "Longitud"
        case idOficina = "IdOficina"
        case latitud = "Latitud"
        case nombre = "Nombre"
    }
}
