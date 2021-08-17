//
//  PostAppErrors.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/13/21.
//

import Foundation

// get errors
enum PostErrorsGet: Error, LocalizedError{
    case failCatchPosts
   
    var errorMsg: String {
        switch self {
        case .failCatchPosts:
            return NSLocalizedString("Fail to catch posts", comment: "")
   
    }
    }
}


// posts errors
enum PostErrorsPost: Error, LocalizedError{
    case unknown
 
    var errorMsg: String {
        switch self {
     
        case .unknown:
            return NSLocalizedString("unknown", comment: "")
   
    }
    }
}

// field validations errors
enum PostValidateFieldsErrors: Error, LocalizedError{
    case title
    case description
    case image
    
    var errorMsg: String{
        switch self {
        case .title:
            return NSLocalizedString("Title is required.", comment: "")
        case .description:
            return NSLocalizedString("Description is required.", comment: "")
        case .image:
            return NSLocalizedString("Image is required.", comment: "")

        }
    }
}

enum PostErrorsDelete: Error, LocalizedError{
    case failDelete
    
    var errorMsg: String{
        switch self {
        case .failDelete:
            return NSLocalizedString("Something went wrong", comment: "")

        }
}
}





struct PostUniversalErrorsMessage: Decodable, Identifiable{
    let id: UUID?
    var messageError: String
    
    
    init(messageError: String){
        self.id = UUID()
        self.messageError = messageError
    }
}
