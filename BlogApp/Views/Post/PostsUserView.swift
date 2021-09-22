//
//  PostsUserView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/14/21.
//

import SwiftUI
import UIKit

struct PostsUserView: View {
    
    @EnvironmentObject var postService: PostServices
    @EnvironmentObject var userService: UserServices
    @EnvironmentObject var selectedPost: CurrentPostSelected


    
    var body: some View {
        
        
        
        VStack{
            if postService.loadingPost{
      
            
                ProgressView()
            
            
            }else{
                if postService.posts.count > 0{
          
                ScrollView(showsIndicators: false){
                    VStack(spacing:20){
                        ForEach(postService.posts, id: \._id){ post in
                            CardView(post: post)
                             
                        }
                    }.padding(.horizontal)
                    .padding(.bottom, 10)

                }
                }else{
                    Text("Empty")
                     .font(.title)
                }
            }
            
        }.navigationTitle("My Posts")
      
        .onAppear{
            DispatchQueue.main.async {
                postService.runGetPostsCurrentUser()
            }
        }
        .alert(item: $postService.postError){ message in
            Alert(title: Text("Error"), message: Text(message.messageError))
        }
        .fullScreenCover(isPresented: $selectedPost.showEdit){
            EditView()
                .environmentObject(postService)
        }
        
        
    }
    
    func onDismiss(){
        print("ffff")
    }
    
    
    
  
    
}

struct PostsUserView_Previews: PreviewProvider {
    static var previews: some View {
        PostsUserView()
            .environmentObject(UserServices())
            .environmentObject(PostServices())
            .environmentObject(CurrentPostSelected())
    }
}
