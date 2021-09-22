//
//  LoginView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import SwiftUI



struct LoginView: View {
    
    @EnvironmentObject var userService: UserServices

    @State var email = ""
    @State var password = ""
    
    
    
    var body: some View {
        
        VStack{
            
            Text("Login")
                .font(.title)
                .bold()
                .padding(.top, 100)
                .padding(.bottom, 30)
            
        
            VStack(alignment: .leading){
            TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
            Divider()
            SecureField("Password", text: $password)
                
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            .padding(.bottom,30)
     
            
            Button(action: {
                do{
                    try self.loginUser()
                }catch{
                    print(error)
                }
                
            }, label: {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding()
            })
            .background(Color.blue)
            .cornerRadius(20)
            .padding(.bottom,30)
           
            
            
            
                HStack{
                    Text("Do you need an account?")
                        .foregroundColor(.gray)
                    NavigationLink(destination: RegisterView()){
                    Text("Register")
                        .foregroundColor(.blue)
                    }
                }
            
            
            Spacer()
            
        }
        .padding()
        .alert(item: $userService.userError){error in
            Alert(title: Text("Error"), message: Text(error.messageError))
        }
        
      
       
        
    }
    
    func loginUser() throws {
        do{
            try login()
        }catch LoginValidateFieldsErrors.email{
            self.userService.userError = UserUniversalErrorsMessage(messageError: LoginValidateFieldsErrors.email.errorMsg)
            
        }catch LoginValidateFieldsErrors.invalidEmail{
            self.userService.userError = UserUniversalErrorsMessage(messageError: LoginValidateFieldsErrors.invalidEmail.errorMsg)

        }catch LoginValidateFieldsErrors.password{
            self.userService.userError = UserUniversalErrorsMessage(messageError: LoginValidateFieldsErrors.password.errorMsg)

        }catch LoginValidateFieldsErrors.passwordLength{
            self.userService.userError = UserUniversalErrorsMessage(messageError: LoginValidateFieldsErrors.passwordLength.errorMsg)
        }
        
    }
    
   
    
    
    func login() throws {
        if self.email.isEmpty{
            throw LoginValidateFieldsErrors.email
            
        }else if !AuthValidations.isValidEmail(testStr: self.email){
            throw LoginValidateFieldsErrors.invalidEmail
            
        }else if self.password.isEmpty{
            throw LoginValidateFieldsErrors.password
            
        }else if !AuthValidations.passwordLength(string: self.password){
            throw LoginValidateFieldsErrors.passwordLength
            
        }else{
            userService.runLogin(email: email, password: password)
        }
        
        
        
        
    }
    
    
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(UserServices())
    }
}
