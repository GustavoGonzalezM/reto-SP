//
//  NetworkingProvide.swift
//  RetoSP
//
//  Created by Gustavo Gonzalez on 30/11/22.
//
// gustavogonzalezmejia@gmail.com
// vdYc38kG85V2

import Foundation

final class NetworkingProvider {
    
    func login(user: String, password: String, success: @escaping (_ user: User) -> (), failure: @escaping (_ error: Error?) -> () ) {
        
        guard let url = URL(string: "https://6w33tkx4f9.execute-api.us-east-1.amazonaws.com/RS_Usuarios?idUsuario=\(user)&clave=\(password)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error en data")
                return
            }
            
            do {
                var decodedData = try JSONDecoder().decode(User.self, from: data)
                if decodedData.access {
                    decodedData.email = user
                    UserDefaults.standard.set(true, forKey: "enrolled")
                    UserDefaults.standard.storeCodable(decodedData, key: "user")
                }
                success(decodedData)
                
            } catch {
                print(error.localizedDescription)
                failure(error)
            }
        }.resume()
    }
    
    func getOffices(success: @escaping (_ sophos: Sophos) -> (), failure: @escaping (_ error: Error?) -> ()) {
        
        guard let url = URL(string: "https://6w33tkx4f9.execute-api.us-east-1.amazonaws.com/RS_Oficinas") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error en data")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Sophos.self, from: data)
                
                success(decodedData)
                
            } catch {
                print(error.localizedDescription)
                failure(error)
            }
        }.resume()
        
    }
    
    func uploadDocument(newDocument: NewDocument, completion: @escaping (Bool) -> ()) {
        guard let url = URL(string: "https://6w33tkx4f9.execute-api.us-east-1.amazonaws.com/RS_Documentos") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(newDocument)
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            do {
                let response = try JSONDecoder().decode(NewDocumentResponse.self, from: data)
                if response.response {
                    completion(true)
                }
            } catch {
                completion(false)
            }
        }.resume()
    }
    
    func getDocuments(success: @escaping (_ documents: Documents) -> (), failure: @escaping (_ error: Error?) -> ()) {
        guard let user: User = UserDefaults.standard.retrieveCodable(for: "user") else { return }
        guard let email = user.email else { return }
        guard let url = URL(string: "https://6w33tkx4f9.execute-api.us-east-1.amazonaws.com/RS_Documentos?correo=\(email)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error en data")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(Documents.self, from: data)
                success(decodedData)
                
            } catch {
                print(error.localizedDescription)
                failure(error)
            }
        }.resume()
        
    }
    
    func viewDocument(documentId: String, success: @escaping (_ document: ViewDocument) -> (), failure: @escaping (_ error: Error?) -> ()) {
        guard let user: User = UserDefaults.standard.retrieveCodable(for: "user") else { return }
        guard let email = user.email else { return }
        guard let url = URL(string: "https://6w33tkx4f9.execute-api.us-east-1.amazonaws.com/RS_Documentos?correo=\(email)&&idRegistro=\(documentId)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("error en data")
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(ViewDocument.self, from: data)
                if decodedData.items?.count == 0 {
                    failure(error)
                } else {
                    success(decodedData)
                }
                
            } catch {
                print(error.localizedDescription)
                failure(error)
            }
        }.resume()
        
    }
    
}

