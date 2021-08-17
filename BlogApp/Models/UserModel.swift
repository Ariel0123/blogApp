//
//  UserModel.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import Foundation
import SwiftUI


struct UserModel: Codable {
    let name: String
    let email: String
    let photoUser: String?
}


struct TokenModel: Codable {
    let token: String
    let authorId: String
    let name: String
}

