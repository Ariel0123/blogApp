//
//  RegisterView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/11/21.
//

import SwiftUI

struct RegisterView: View {
    @State var name = ""
    @State var email = ""
    @State var password = ""
    @State var passwordConfirm = ""
    
    @EnvironmentObject var userService: UserServices
    
    
    var body: some View {
        
        VStack{
            
            Text("Register")
                .font(.title)
                .bold()
                .padding(.top, 100)
                .padding(.bottom, 30)
            
        
            VStack(alignment: .leading){
            TextField("Name", text: $name)
            Divider()
            TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            Divider()
                SecureField("Password", text: $password)
                Divider()
                SecureField("Confirm password", text: $passwordConfirm)
                
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20)
            .padding(.bottom,30)
     
            
            Button(action: {
                do{
                    try self.registerUser()
                }catch{
                    print(error)
                }
            }, label: {
                Text("Register")
                    .foregroundColor(.white)
                    .frame(width: 200)
                    .padding()
            })
            .background(Color.blue)
            .cornerRadius(20)
            .padding(.bottom,30)
            
            
          
            
            Spacer()
            
        }
        .padding()
        .alert(item: $userService.userError){error in
            Alert(title: Text("Error"), message: Text(error.messageError))
        }
       
        
    }
    

    
    func registerUser() throws {
        do{
            try register()
        }catch RegisterValidateFieldsErrors.name{
            self.userService.userError = UserUniversalErrorsMessage(messageError: RegisterValidateFieldsErrors.name.errorMsg)
            
        }catch RegisterValidateFieldsErrors.email{
            self.userService.userError = UserUniversalErrorsMessage(messageError: RegisterValidateFieldsErrors.email.errorMsg)
            
        }catch RegisterValidateFieldsErrors.invalidEmail{
            self.userService.userError = UserUniversalErrorsMessage(messageError: RegisterValidateFieldsErrors.invalidEmail.errorMsg)

        }catch RegisterValidateFieldsErrors.password{
            self.userService.userError = UserUniversalErrorsMessage(messageError: RegisterValidateFieldsErrors.password.errorMsg)

        }catch RegisterValidateFieldsErrors.passwordLength{
            self.userService.userError = UserUniversalErrorsMessage(messageError: RegisterValidateFieldsErrors.passwordLength.errorMsg)
            
        }catch RegisterValidateFieldsErrors.passwordConfirm{
            self.userService.userError = UserUniversalErrorsMessage(messageError: RegisterValidateFieldsErrors.passwordConfirm.errorMsg)
            
        }catch RegisterValidateFieldsErrors.passwordMatch{
            self.userService.userError = UserUniversalErrorsMessage(messageError: RegisterValidateFieldsErrors.passwordMatch.errorMsg)
            }
        
        
    }
    
   
    
    
    func register() throws {
        if self.name.isEmpty {
            throw RegisterValidateFieldsErrors.name
        
        }else if self.email.isEmpty{
            throw RegisterValidateFieldsErrors.email
            
        }else if !AuthValidations.isValidEmail(testStr: self.email){
            throw RegisterValidateFieldsErrors.invalidEmail
            
        }else if self.password.isEmpty{
            throw RegisterValidateFieldsErrors.password
            
        }else if !AuthValidations.passwordLength(string: self.password){
            throw RegisterValidateFieldsErrors.passwordLength
            
        }else if self.passwordConfirm.isEmpty{
            throw RegisterValidateFieldsErrors.passwordConfirm
            
        }else if !AuthValidations.passwordMatch(pass1: self.password, pass2: self.passwordConfirm){
            throw RegisterValidateFieldsErrors.passwordMatch
            
        }else{
            userService.runRegister(name: name, email: email, password: password)

        }
   
        
    }
    
    
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(UserServices())

    }
}
