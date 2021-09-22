//
//  UserServices.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import Foundation
import Combine
import KeychainSwift
import UIKit


class UserServices: ObservableObject{
    
    //var didChange = PassthroughSubject<UserServices, Never>()
    
    //@Published var isAuthenticated: Bool = false{
        //didSet{
            //didChange.send(self)
        //}
    //}
    
    @Published var isAuthenticated: Bool = false
    @Published var userInfo: TokenModel? = nil
    
    @Published var userProfile: UserModel? = nil
    @Published var loadingProfile = false
    
    
    @Published var userError: UserUniversalErrorsMessage? = nil
    

    
    let baseURL = "http://localhost:4000/api"
    
    init(){
        
        
    }
    
    func runLogin(email: String, password: String){
        do{
            try login(email: email, password: password){msg in
                switch msg{
                case .success(let result):
                    DispatchQueue.main.async {
                            
                            self.isAuthenticated = true
                            self.userInfo = result
                            
                            self.storeToken(token: result.token as String)
                      
                        
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.userError = UserUniversalErrorsMessage(messageError: error.errorMsg)
                    }
                }
            
            }
            
        }catch{
            print("error")
        }
    }
    
    
    private func login(email: String, password: String, completion: @escaping (Result<TokenModel, UserErrorsApp>) -> ()) throws {
        
        let urlLogin = "\(baseURL)/user/login"
        
        guard let url = URL(string: urlLogin) else {return}
        
        let body = ["email": email.lowercased(), "password": password.lowercased()]
        
        guard let finalBody = try? JSONSerialization.data(withJSONObject: body, options: .init()) else {return}
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? UserErrorsApp ?? .failCatchUser))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(TokenModel.self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    DispatchQueue.main.async {
                    let error = try! JSONDecoder().decode(UserUniversalErrorsMessage.self, from: data)
                    self.userError = UserUniversalErrorsMessage(messageError: error.messageError)
                    }
                }
            }else{
                completion(.failure(.failCatchUser))

            }
            
            
        }.resume()
        
    }
    
    
    func runRegister(name: String, email: String, password: String){
        do{
            try register(name: name, email: email, password: password){msg in
                switch msg{
                case .success(let result):
                    DispatchQueue.main.async {
                            
                            self.isAuthenticated = true
                            self.userInfo = result

                            
                            self.storeToken(token: result.token as String)
                      
                        }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.userError = UserUniversalErrorsMessage(messageError: error.errorMsg)
                    }
                }
            
            }
            
        }catch{
            print("error")
        }
    }
    
    
    private func register(name: String,email: String, password: String, completion: @escaping (Result<TokenModel, UserErrorsApp>) -> ()) throws {
        
        let urlRegister = "\(baseURL)/user/register"
        
        guard let url = URL(string: urlRegister) else {return}
        
        let body = ["name": name.lowercased(), "email": email.lowercased(), "password": password.lowercased()]
        
        guard let finalBody = try? JSONSerialization.data(withJSONObject: body, options: .init()) else {return}
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? UserErrorsApp ?? .failCatchUser))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(TokenModel.self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    DispatchQueue.main.async {
                    let error = try! JSONDecoder().decode(UserUniversalErrorsMessage.self, from: data)
                    self.userError = UserUniversalErrorsMessage(messageError: error.messageError)
                    }
                }
            }else{
                completion(.failure(.failCatchUser))

            }
            
            
        }.resume()
        
    }
    
    
    func runGetUser(){
        do{
            try getUser(){msg in
                switch msg{
                case .success(let result):
                    DispatchQueue.main.async {
                        self.loadingProfile = false
                    self.userProfile = result
                        
                    }
                case .failure(let error):
                    self.loadingProfile = false

                    self.userError = UserUniversalErrorsMessage(messageError: error.errorMsg)
                }
            }
        }catch{
            print(error)
        }
    }
    
    
    func getUser(completion: @escaping (Result<UserModel, UserErrorsGetProfile>)->()) throws {
        
        self.loadingProfile = true
        
        let urlProfile = "\(baseURL)/user/profile"
        
        guard let url = URL(string: urlProfile) else {return}
        
        let keychain = KeychainSwift()
        let key = keychain.get("token")
        
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "auth-token")
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? UserErrorsGetProfile ?? .failGet))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(UserModel.self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    DispatchQueue.main.async {
                    let error = try! JSONDecoder().decode(UserUniversalErrorsMessage.self, from: data)
                        self.userError = UserUniversalErrorsMessage(messageError: error.messageError)
                    }
                }
            }else{
                completion(.failure(.failGet))

            }
            
            
        }.resume()
    }
    
    
    func runUpdateProfile(name: String, email: String, image: UIImage, filename: String, format: String){
        do{
            try updateProfile(name: name, email: email, image: image, filename: filename, format: format){msg in
                switch msg{
                case .success(_):
                    DispatchQueue.main.async {
                        self.runGetUser()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                    self.userError = UserUniversalErrorsMessage(messageError: error.errorMsg)
                    }
                }
            }
            
        }catch{
            
        }
        
    }
    
    func updateProfile(name: String, email: String, image: UIImage, filename: String, format: String, completion: @escaping (Result<SuccessOperation, UserErrorsUpdateProfile>)->()) throws{
        
        
        let urlProfile = "\(baseURL)/user/update"
        
        guard let url = URL(string: urlProfile) else {return}
        
        let keychain = KeychainSwift()
        let key = keychain.get("token")
        let keyString = key!.description
        
        print(image)
        
        guard let mediaImage = Media(withImage: image, forKey: "photoUser", filename: filename, mimeType: format) else { return }
        
        let body = ["name": name, "email": email]
        
        let boundary = generateBoundary()

        
        var request = URLRequest(url: url)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(keyString, forHTTPHeaderField: "auth-token")
        request.httpMethod = "PUT"
        
        let dataBody = createDataBody(withParameters: body, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? UserErrorsUpdateProfile ?? .failUpdate))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(SuccessOperation.self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    completion(.failure(.failUpdate))
                }
            }else{
                completion(.failure(.failUpdate))

            }
            
            
        }.resume()
        
    }
    
    
    func runDeleteUser(){
        do{
            try deleteUser(){msg in
                switch msg{
                case .success(_):
                    DispatchQueue.main.async {
                        self.logout()
                    }
                case .failure(let error):
                    self.userError = UserUniversalErrorsMessage(messageError: error.errorMsg)
                }
            }
            
        }catch{
            print(error)
        }
    }
    
    
    func deleteUser(completion: @escaping (Result<SuccessOperation, UserErrorsDeleteProfile>)->()) throws {
        
        let urlProfile = "\(baseURL)/user/delete"
        
        guard let url = URL(string: urlProfile) else {return}
        
        let keychain = KeychainSwift()
        let key = keychain.get("token")
        let keyString = key!.description
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(keyString, forHTTPHeaderField: "auth-token")
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? UserErrorsDeleteProfile ?? .failDelete))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(SuccessOperation.self, from: data)

                    completion(.success(result))
                    
                }catch{
                    DispatchQueue.main.async {
                    let error = try! JSONDecoder().decode(UserUniversalErrorsMessage.self, from: data)
                        self.userError = UserUniversalErrorsMessage(messageError: error.messageError)

                    }
                    
                }
            }else{
                completion(.failure(.failDelete))

            }
            
        }.resume()
        
    
    }
    
    
    func logout(){
      
        let keychain = KeychainSwift()
        keychain.delete("token")
        self.isAuthenticated = false
        self.userInfo = nil
        self.userProfile = nil
        self.userError = nil
            
        
        
    }
    
    func storeToken(token: String)  {
        
        let keychain = KeychainSwift()
        keychain.set(token, forKey: "token")
    }
    
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
            
            let lineBreak = "\r\n"
            var body = Data()
            
            if let parameters = params {
                for (key, value) in parameters {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                    body.append("\(value + lineBreak)")
                }
            }
            
            if let media = media {
                for photo in media {
                    body.append("--\(boundary + lineBreak)")
                    body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                    body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                    body.append(photo.data)
                    body.append(lineBreak)
                }
            }
            
            body.append("--\(boundary)--\(lineBreak)")
            
            return body
        }
    
    func generateBoundary() -> String {
         return "Boundary-\(NSUUID().uuidString)"
     }
}
