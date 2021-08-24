//
//  DetailView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/15/21.
//

import SwiftUI
import Kingfisher

struct DetailView: View {
    
    let post: PostModel
    
    var body: some View {
        ScrollView(showsIndicators: false){
            KFImage(URL(string: "http://localhost:4000/"+post.image))
                .resizable()
                .scaledToFit()
            VStack(alignment: .leading, spacing:0){
            
                Text(post.title)
                .font(.title)
                .padding(.bottom)
                
                
                Text(post.username.capitalized)
                    .font(.caption)
                
                Text(post.date)
                .font(.caption)
                .padding(.bottom)
                .foregroundColor(.gray)
         
            
                Text(post.description)
            
        }
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
        .padding(.horizontal)
      
        }

        .ignoresSafeArea()

    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(post: PostModel(_id: "", title: "", description: "", image: "", author: "", username: "",  date: ""))
    }
}
