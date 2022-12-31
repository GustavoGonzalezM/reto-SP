//
//  Documents.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 31/12/22.
//

import Foundation

struct NewDocument: Codable {
    let tipoId: String
    let identificacion: String
    let nombre: String
    let apellido: String
    let ciudad: String
    let correo: String
    let tipoAdjunto: String
    let adjunto: String
    
    enum CodingKeys: String, CodingKey {
        case tipoId = "TipoId"
        case identificacion = "Identificacion"
        case nombre = "Nombre"
        case apellido = "Apellido"
        case ciudad = "Ciudad"
        case correo = "Correo"
        case tipoAdjunto = "TipoAdjunto"
        case adjunto = "Adjunto"
    }
}

struct NewDocumentResponse: Codable {
    let response: Bool
    
    enum CodingKeys: String, CodingKey {
        case response = "put"
    }
}

