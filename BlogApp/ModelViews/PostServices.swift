//
//  PostServices.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import Foundation
import KeychainSwift
import UIKit


typealias Parameters = [String: String]

class PostServices: ObservableObject{
    
    @Published var postsAll = [PostModel]()
    @Published var loadingPostAll = false

    @Published var posts = [PostModel]()
    @Published var loadingPost = false
    
    @Published var postError: PostUniversalErrorsMessage? = nil


    let baseURL = "http://localhost:4000/api"
    
    init(){
        
    }
    
    
    func runGetPosts(){
        do{
            try getPosts(){msg in
                switch msg{
                case .success(let result):
                    DispatchQueue.main.async {
                        self.loadingPostAll = false
                        self.postsAll = result
                        }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.loadingPostAll = false

                        self.postError = PostUniversalErrorsMessage(messageError: error.errorMsg)
                    }
                }
            
            }
            
        }catch{
            print("error")
        }
    }
    
    private func getPosts(completion: @escaping (Result<[PostModel], PostErrorsGet>) -> ()) throws {
        
        self.loadingPostAll = true
        
        let urlPosts = "\(baseURL)/posts/all"
        
        guard let url = URL(string: urlPosts) else {return}
        
        let keychain = KeychainSwift()
        let key = keychain.get("token")
        
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "auth-token")
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? PostErrorsGet ?? .failCatchPosts))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode([PostModel].self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    DispatchQueue.main.async {
                    let error = try! JSONDecoder().decode(PostUniversalErrorsMessage.self, from: data)
                        self.postError = PostUniversalErrorsMessage(messageError: error.messageError)
                    }
                }
            }else{
                completion(.failure(.failCatchPosts))

            }
            
            
        }.resume()
        
    }
    
    
    
    func runGetPostsCurrentUser(){
        do{
            try getPostsCurrentUser(){msg in
                switch msg{
                case .success(let result):
                    DispatchQueue.main.async {
                        self.loadingPost = false
                        self.posts = result
                        }
                    
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.loadingPost = false
                        self.postError = PostUniversalErrorsMessage(messageError: error.errorMsg)
                    }
                }
            
            }
            
        }catch{
            print("error")
        }
    }
    
    private func getPostsCurrentUser(completion: @escaping (Result<[PostModel], PostErrorsGet>) -> ()) throws {
        
        self.loadingPost = true
        
        let urlPosts = "\(baseURL)/posts"
        
        guard let url = URL(string: urlPosts) else {return}
        
        let keychain = KeychainSwift()
        let key = keychain.get("token")
        
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(key, forHTTPHeaderField: "auth-token")
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? PostErrorsGet ?? .failCatchPosts))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode([PostModel].self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    DispatchQueue.main.async {
                       
                    let error = try! JSONDecoder().decode(PostUniversalErrorsMessage.self, from: data)
                        self.postError = PostUniversalErrorsMessage(messageError: error.messageError)
                    }
                }
            }else{
                completion(.failure(.failCatchPosts))

            }
            
            
        }.resume()
        
    }
    
    
    func runCreatePost(title: String, description: String, image: UIImage, name: String, format: String){
        
        do{
        try createPost(title: title, description: description, image: image, name: name, format: format){result in
            switch result{
            case .success(_):
                DispatchQueue.main.async {
                   self.runGetPostsCurrentUser()

                }
            case .failure(let error):
                self.postError = PostUniversalErrorsMessage(messageError: error.errorMsg)
            }
        }
        }catch{
            print("error")

        }
     
       
    }
    
    
   
    
    private func createPost(title: String, description: String, image: UIImage, name: String, format: String, completion: @escaping (Result<PostModel, PostErrorsPost>)->()) throws {
        
        let urlPosts = "\(baseURL)/posts"
        
        guard let url = URL(string: urlPosts) else {return}
        
        let keychain = KeychainSwift()
        let key = keychain.get("token")
        let keyString = key!.description
        
        guard let mediaImage = Media(withImage: image, forKey: "image", filename: name, mimeType: format) else { return }
        
        let body = ["title": title, "description": description]
        
        let boundary = generateBoundary()

        
        var request = URLRequest(url: url)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(keyString, forHTTPHeaderField: "auth-token")
        request.httpMethod = "POST"
        
        let dataBody = createDataBody(withParameters: body, media: [mediaImage], boundary: boundary)
        request.httpBody = dataBody
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? PostErrorsPost ?? .unknown))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(PostModel.self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    completion(.failure(.unknown))
                }
            }else{
                completion(.failure(.unknown))

            }
            
            
        }.resume()
        
       
    }
    
    func runUpdatePost(id: String, title: String?, description: String?, image: UIImage?, name: String, format: String){
        do{
            try updatePost(id: id, title: title, description: description, image: image, name: name, format: format){msg in
                switch msg{
                case .success(_):
                    DispatchQueue.main.async {
                     
                    self.runGetPosts()
                        self.runGetPostsCurrentUser()
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                    self.postError = PostUniversalErrorsMessage(messageError: error.errorMsg)
                    }
                }
                
            }
        }catch{
            print(error)
        }
    }
    
    
    private func updatePost(id: String, title: String?, description: String?, image: UIImage?, name: String, format: String, completion: @escaping (Result<PostModel, PostErrorsPost>)->()) throws {
        
        let urlPosts = "\(baseURL)/posts/\(id)"
        
        guard let url = URL(string: urlPosts) else {return}
        
        let keychain = KeychainSwift()
        let key = keychain.get("token")
        let keyString = key!.description
        
        var request = URLRequest(url: url)
        
        if !name.isEmpty{
        
            guard let mediaImage = Media(withImage: image!, forKey: "image", filename: name, mimeType: format) else { return }
            
            let body = ["title": title!, "description": description!]
            
            let boundary = generateBoundary()

            
           
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.setValue(keyString, forHTTPHeaderField: "auth-token")
            request.httpMethod = "PUT"
            
            let dataBody = createDataBody(withParameters: body, media: [mediaImage], boundary: boundary)
            request.httpBody = dataBody
            
            
        }else{
            let body = ["title": title, "description": description]
            
            guard let finalBody = try? JSONSerialization.data(withJSONObject: body, options: .init()) else {return}
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(keyString, forHTTPHeaderField: "auth-token")
            request.httpMethod = "PUT"
            request.httpBody = finalBody
        }
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? PostErrorsPost ?? .unknown))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(PostModel.self, from: data)
                    
                    completion(.success(result))
                    
                    
                }catch{
                    DispatchQueue.main.async {
                       
                    let error = try! JSONDecoder().decode(PostUniversalErrorsMessage.self, from: data)
                        self.postError = PostUniversalErrorsMessage(messageError: error.messageError)
                    }
                }
            }else{
                completion(.failure(.unknown))

            }
            
            
        }.resume()
        
       
    }
    
    
    
    
    func runDeletePost(id: String){
        
        do{
            try deletePost(id: id){result in
                switch result{
                case .success(_):
                    DispatchQueue.main.async {
                
                    self.runGetPosts()
                    self.runGetPostsCurrentUser()
                    }
                    
                case .failure(let error):
                    self.postError = PostUniversalErrorsMessage(messageError: error.errorMsg)
                }
               
            }
            
        }catch{
            print(error)
        }
    }
    
    
    func deletePost(id: String, completion: @escaping (Result<SuccessOperation, PostErrorsDelete>)->()) throws {
        
        let urlPosts = "\(baseURL)/posts/\(id)"
        
        guard let url = URL(string: urlPosts) else {return}
        
        let keychain = KeychainSwift()
        let key = keychain.get("token")
        let keyString = key!.description
        
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(keyString, forHTTPHeaderField: "auth-token")
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) {(data, response, err) in
            
            if let err = err{
                completion(.failure(err as? PostErrorsDelete ?? .failDelete))
                return
            }else if let data = data{
                
                do{
                    let result = try JSONDecoder().decode(SuccessOperation.self, from: data)

                    completion(.success(result))
                    
                }catch{
                    DispatchQueue.main.async {
                    let error = try! JSONDecoder().decode(PostUniversalErrorsMessage.self, from: data)
                    self.postError = PostUniversalErrorsMessage(messageError: error.messageError)
                    }
                    
                }
            }else{
                completion(.failure(.failDelete))

            }
            
        }.resume()
        
    
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


extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
