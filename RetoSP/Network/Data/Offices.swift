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
    let city: String
    let longitude: String
    let officeId: Int
    let latitude: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case city = "Ciudad"
        case longitude = "Longitud"
        case officeId = "IdOficina"
        case latitude = "Latitud"
        case name = "Nombre"
    }
}
