//
//  User.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 30/11/22.
//

import Foundation

struct User: Codable {
    let id: String?
    let name: String?
    let lastName: String?
    let access: Bool
    let admin: Bool?
    var email: String?
    
    enum CodingKeys: String, CodingKey {
        case id  = "id"
        case name  = "nombre"
        case lastName  = "apellido"
        case access  = "acceso"
        case admin  = "admin"
        case email  = "email"
    }
}
