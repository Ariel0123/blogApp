//
//  BlogAppApp.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import SwiftUI

@main
struct BlogAppApp: App {
    
    @StateObject private var userServices = UserServices()
    @StateObject private var postServices = PostServices()
    @StateObject private var currentPost = CurrentPostSelected()


    
    var body: some Scene {
        WindowGroup {
            StateView()
                .environmentObject(userServices)
                .environmentObject(postServices)
                .environmentObject(currentPost)

                
        }
    }
}
