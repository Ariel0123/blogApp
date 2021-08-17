//
//  CardView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import SwiftUI
import Kingfisher



struct CardView: View {
    
        
        
    @EnvironmentObject var userService: UserServices
    @EnvironmentObject var postService: PostServices
    @EnvironmentObject var selectedPost: CurrentPostSelected
    
    let post: PostModel
    
    var body: some View {
        ZStack{
            
        
            KFImage(URL(string: "http://localhost:4000/"+post.image))
                .resizable()
                .scaledToFill()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 380)
                .overlay(Color.black.opacity(0.2))
            
            
           
            
            VStack {
                if post.author == userService.userInfo?.authorId{

                HStack {
                    Spacer()
                    VStack{
                        Menu {
                            
                            
                            Button {
                                
                                DispatchQueue.main.async {
                                    self.selectedPost.postCurrent = post
                                    self.selectedPost.showEdit.toggle()
                                }
                            } label: {
                                HStack{
                                    Text("Edit")
                                    Image(systemName: "pencil")
                                }
                            }
                            
                            Button {
                                DispatchQueue.main.async {
                                
                                    postService.runDeletePost(id: post._id)
                                }
                            } label: {
                                HStack{
                                    Text("Delete")
                                Image(systemName: "trash.fill")
                                }
                            }
                           
                            
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        }
                        Spacer()
                    }
                }.padding()
                .frame(height: 50)
                }
                
                Spacer()
                NavigationLink(destination: DetailView(post: post)){

                HStack {
                    VStack(alignment: .leading){
                        
                        
                        Text(post.title)
                            .frame(height: 8)
                            .font(.headline)
                            .padding(.bottom,1)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 10, alignment: .leading)

                            
                        
                        
                        Text(post.description)
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .frame(width: 300, height: 70, alignment: .leading)
                        
                    }
                    
                    Spacer()
                }.padding()
                .frame(height: 110, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
            }
            
            
     
            
            
        }
        .cornerRadius(20)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 380)

        
        
    }
    
    
   
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(post: PostModel(_id: "", title: "", description: "", image: "", author: "", username: "",  date: ""))
    }
}



