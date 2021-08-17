//
//  PostModel.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import Foundation
import UIKit

struct PostModel: Codable {
    let _id: String
    let title: String
    let description: String
    let image: String
    let author: String
    let username: String
    let date: String
    
}




struct SuccessOperation: Codable{
    let messageSuccess: String
}


class CurrentPostSelected: ObservableObject{
    @Published var postCurrent: PostModel? = nil
    @Published var showEdit = false
    

    
    
}
