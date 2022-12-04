//
//  User.swift
//  RetoSP
//
//  Created by Usuario on 30/11/22.
//



//{
//"ïd" : "115",
//"nombre" : "Gustavo",
//"apellido" : "Gonzalez",
//"acceso" : true,
//"admin" : false

//}

import Foundation

struct User: Codable {
    let id: String?
    let nombre: String?
    let apellido: String?
    let acceso: Bool
    let admin: Bool?
    let email: String?
}
