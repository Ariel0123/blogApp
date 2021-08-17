//
//  TabView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/12/21.
//

import SwiftUI

struct TabControlView: View {
    
    
    @State private var tabSelection = 0
    
    let tabImages = ["house.fill", "list.bullet.rectangle", "person.fill", "plus.circle.fill"]
    
    
    var body: some View {
        
        VStack(spacing: 0){
            ZStack{
                
                
                switch tabSelection {
                
                
                case 0:
                    NavigationView{
                        HomeView()
                    }
                    .accentColor(.white)

                case 1:
                    NavigationView{
                        PostsUserView()
                    }
                    .accentColor(.white)

                    
                case 2:
                    NavigationView{
                        ProfileView()
                    }
                    
                default:
                    NavigationView{
                        CreateView(tabSelection: $tabSelection)
                        
                        
                    }
                }
                
            }
            
            Divider()
                .padding(.bottom,10)
            
            HStack{
                ForEach(0..<4){ num in
                    Button(action: {
                        tabSelection = num
                        
                    }, label: {
                        Spacer()
                        Image(systemName: tabImages[num])
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(tabSelection == num ? .blue : .gray)
                        Spacer()
                    })
                }
            }
            
            
        }
    }
}

struct TabControlView_Previews: PreviewProvider {
    static var previews: some View {
        TabControlView()
    }
}
