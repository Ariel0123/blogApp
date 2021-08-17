//
//  UserAppErrors.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/13/21.
//

import Foundation

enum UserErrorsApp: Error, LocalizedError{
    case failCatchUser
    
    var errorMsg: String {
        switch self {
        case .failCatchUser:
            return NSLocalizedString("Fail to catch user", comment: "")
         
    }
    }
}


// field validations errors
enum LoginValidateFieldsErrors: Error, LocalizedError{
    case email
    case invalidEmail
    case password
    case passwordLength

    
    var errorMsg: String{
        switch self {
        case .email:
            return NSLocalizedString("Email is required.", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid email.", comment: "")
        case .password:
            return NSLocalizedString("Password is required.", comment: "")
        case .passwordLength:
            return NSLocalizedString("Password must have a minimum of 6 characters.", comment: "")
     

        }
    }
}

enum RegisterValidateFieldsErrors: Error, LocalizedError{
    case name
    case email
    case invalidEmail
    case password
    case passwordLength
    case passwordConfirm
    case passwordMatch

    
    var errorMsg: String{
        switch self {
        case .name:
            return NSLocalizedString("Name is required.", comment: "")
        case .email:
            return NSLocalizedString("Email is required.", comment: "")
        case .invalidEmail:
            return NSLocalizedString("Invalid email.", comment: "")
        case .password:
            return NSLocalizedString("Password is required.", comment: "")
        case .passwordConfirm:
            return NSLocalizedString("Confirm password is required.", comment: "")
        case .passwordLength:
            return NSLocalizedString("Password must have a minimum of 6 characters.", comment: "")
        case .passwordMatch:
            return NSLocalizedString("Password do not match.", comment: "")
            

        }
    }
}



enum UserErrorsGetProfile: Error, LocalizedError{
    case failGet
    
    var errorMsg: String{
        switch self {
        case .failGet:
            return NSLocalizedString("Something went wrong", comment: "")

        }
}
}

enum UserErrorsUpdateProfile: Error, LocalizedError{
    case failUpdate
    
    var errorMsg: String{
        switch self {
        case .failUpdate:
            return NSLocalizedString("Something went wrong", comment: "")

        }
}
}

enum UserErrorsDeleteProfile: Error, LocalizedError{
    case failDelete
    
    var errorMsg: String{
        switch self {
        case .failDelete:
            return NSLocalizedString("Something went wrong", comment: "")

        }
}
}


struct UserUniversalErrorsMessage: Decodable, Identifiable{
    let id: UUID?
    var messageError: String
    
    
    init(messageError: String){
        self.id = UUID()
        self.messageError = messageError
    }
}
