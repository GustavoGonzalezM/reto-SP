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
    
    static let shared = NetworkingProvider()
    
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
                let decodedData = try JSONDecoder().decode(User.self, from: data)
                if decodedData.acceso {
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
}
