//
//  HomeView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var postService: PostServices
    @EnvironmentObject var userService: UserServices
    @EnvironmentObject var selectedPost: CurrentPostSelected

    
    var body: some View {
        
        
        
        VStack{
            
            if postService.loadingPostAll{
      
            
                ProgressView()
            
            
            }else{
                if postService.postsAll.count > 0{
          
                ScrollView(showsIndicators: false){
                    VStack(spacing:20){
                        ForEach(postService.postsAll, id: \._id){ post in
                            CardView(post: post)
                                .environmentObject(postService)
                            


                        }
                    }.padding(.horizontal)
                    .padding(.bottom, 10)

                }
                }else{
                    Text("Empty")
                     .font(.title)
                }
            }
            
        }.navigationTitle("Home")

        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                Text((userService.userInfo != nil) ? "Welcome "+userService.userInfo!.name : "")

            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
            MenuPopup()
            }
        }
        .onAppear{
            DispatchQueue.main.async {
                
              
                postService.runGetPosts()
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
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
          
    }
}



