//
//  Documents.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 31/12/22.
//

import Foundation

struct NewDocument: Codable {
    let idType: String
    let id: String
    let name: String
    let lastname: String
    let city: String
    let email: String
    let attachmentType: String
    let attachment: String
    
    enum CodingKeys: String, CodingKey {
        case idType = "TipoId"
        case id = "Identificacion"
        case name = "Nombre"
        case lastname = "Apellido"
        case city = "Ciudad"
        case email = "Correo"
        case attachmentType = "TipoAdjunto"
        case attachment = "Adjunto"
    }
}

struct NewDocumentResponse: Codable {
    let response: Bool
    
    enum CodingKeys: String, CodingKey {
        case response = "put"
    }
}

struct Documents: Codable {
    let items: [Document]?

    enum CodingKeys: String, CodingKey {
        case items = "Items"
    }
}

struct Document: Codable {
    let documentId: String?
    let date: String?
    let attachmentType: String?
    let name: String?
    let lastname: String?
    
    enum CodingKeys: String, CodingKey {
        case documentId = "IdRegistro"
        case date = "Fecha"
        case attachmentType = "TipoAdjunto"
        case name = "Nombre"
        case lastname = "Apellido"
    }
}

struct ViewDocument: Codable {
    let items: [ViewDocumentImage]?
    
    enum CodingKeys: String, CodingKey {
        case items = "Items"
    }
}

struct ViewDocumentImage: Codable {
    let city: String?
    let date: String?
    let attachmentType: String?
    let name: String?
    let lastname: String?
    let identification: String?
    let documentId: String?
    let idType: String?
    let email: String?
    let attachment: String?
    
    enum CodingKeys: String, CodingKey {
        case city = "Ciudad"
        case date = "Fecha"
        case attachmentType = "TipoAdjunto"
        case name = "Nombre"
        case lastname = "Apellido"
        case identification = "Identificacion"
        case documentId = "IdRegistro"
        case idType = "TipoId"
        case email = "Correo"
        case attachment = "Adjunto"
    }
}
