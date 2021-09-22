//
//  StateView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import SwiftUI

struct StateView: View {
    @EnvironmentObject var userSevice: UserServices

    
    var body: some View {
        
       
        if userSevice.isAuthenticated{
            TabControlView()
        }else{
            NavigationView{
            LoginView()
            }.navigationViewStyle(StackNavigationViewStyle())

            
        }
        
    }
}

struct StateView_Previews: PreviewProvider {
    static var previews: some View {
        StateView()
            .environmentObject(UserServices())
    }
}
