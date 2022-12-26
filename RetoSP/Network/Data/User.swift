//
//  User.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 30/11/22.
//

import Foundation

struct User: Codable {
    let id: String?
    let nombre: String?
    let apellido: String?
    let acceso: Bool
    let admin: Bool?
    let email: String?
}
