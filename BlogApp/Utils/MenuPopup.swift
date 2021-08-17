//
//  MenuPopup.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import SwiftUI

struct MenuPopup: View {
    
    @EnvironmentObject var userSevice: UserServices
    @Environment(\.colorScheme) var colorScheme

    
    var body: some View {
        VStack{
            
            Menu {
                Button {
                    DispatchQueue.main.async {
                    
                    userSevice.logout()
                    }
                } label: {
                    Text("Logout")
                }
               
                
            } label: {
                Image(systemName: "ellipsis")
                    .frame(width: 30, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .foregroundColor(colorScheme == .dark ? .white : .black)

            }
        }.padding()
    }
}

struct MenuPopup_Previews: PreviewProvider {
    static var previews: some View {
        MenuPopup()
    }
}
