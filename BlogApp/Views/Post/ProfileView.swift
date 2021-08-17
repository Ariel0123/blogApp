//
//  ProfileView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/14/21.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    
    @EnvironmentObject var userService: UserServices

    
    @State var showImagePicker: Bool = false
    @State var image = UIImage()
    @State var imageName = ""
    @State var format = ""
    
    @State var username = ""
    @State var email = ""
    
    @State var editImage = false
    @State var editUsername = false
    @State var editEmail = false
    @State var deleteAccount = false

    
    

    
    var body: some View {
        
        
        ScrollView(showsIndicators: false){
            
            if userService.loadingProfile{
                ProgressView()
            }else{
                if userService.userProfile?.email != ""{
                    VStack{
                        
                        VStack{
                        
                         
                            if ((userService.userProfile?.photoUser) != nil) && (image.cgImage == nil){
                                
                                KFImage(URL(string: "http://localhost:4000/"+userService.userProfile!.photoUser!))
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .clipShape(Capsule())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                                    .padding(.bottom)
                                
                            }else if ((userService.userProfile?.photoUser) != nil) && (image.cgImage != nil){
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .clipShape(Capsule())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                                    .padding(.bottom)
                            }else if ((userService.userProfile?.photoUser) == nil) && (image.cgImage != nil){
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .clipShape(Capsule())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                                    .padding(.bottom)
                            }else{
                                Image("m1")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 180, height: 180, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .clipShape(Capsule())
                                    .overlay(Circle().stroke(Color.gray, lineWidth: 3))
                                    .padding(.bottom)
                            }
                            
                            Button("Edit image", action: {
                                self.showImagePicker.toggle()
                                self.editImage.toggle()
                            })
                            
                        }.padding(.top, 20)
                        .padding(.bottom, 30)
                        
                        
                        
                        
                        
                        VStack{
                        HStack{
                            Text((userService.userProfile != nil) ? userService.userProfile!.name : "")
                            .font(.headline)
                            .padding(.trailing)
                            Spacer()
                            Button(self.editUsername ? "Cancel" : "Edit name", action: {
                                self.editUsername.toggle()
                            })
                        }
                            if self.editUsername{
                        TextField("New name", text: $username)
                            }

                            
                        
                        HStack{
                        Text((userService.userProfile != nil) ? userService.userProfile!.email : "")
                            .font(.headline)
                            .padding(.trailing)
                            Spacer()
                            Button(self.editEmail ? "Cancel" : "Edit email", action: {
                                self.editEmail.toggle()
                            })
                        }
                            
                        .padding(.top)

                            if self.editEmail{
                        TextField("New email", text: $email)
                                
                            }
                            
                            
                           
                            VStack {
                                
                                if editUsername || editEmail || editImage{
                                Button("Update", action: {
                                    do{
                                        try self.updateProfile()
                                    }catch{
                                        print(error)
                                    }
                                    self.editImage = false
                                    self.editEmail = false
                                    self.editUsername = false
                                        
                                })
                                .frame(width: 150, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(20)
                                .padding(.bottom, 20)
                                
                            }
                                
                                
                                
                                Button(self.deleteAccount ? "Cancel" : "Account Delete", action: {
                                    self.deleteAccount.toggle()
                                        
                                })
                                .frame(width: 150, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.white)
                                .background(self.deleteAccount ? Color.gray : Color.red)
                                .cornerRadius(20)
                                
                                
                                if deleteAccount{
                                VStack{
                                
                                    Text("Delete Account")
                                        .font(.title)
                                        .bold()
                                    
                                    Text("Are you sure you want to delete your account?")
                                        .font(.headline)
                                    
                                    HStack{
                                        Button("Delete", action: {
                                            userService.runDeleteUser()
                                            
                                            self.deleteAccount.toggle()
                                                
                                        })
                                        .frame(width: 140, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.white)
                                        .background(Color.red)
                                        .cornerRadius(20)
                                        
                                        Button("Cancel", action: {
                                            self.deleteAccount.toggle()
                                                
                                        })
                                        .frame(width: 140, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                        .foregroundColor(.white)
                                        .background(Color.gray)
                                        .cornerRadius(20)
                                    }
                                    .padding(.top)
                                }
                                .padding(.top)
                                }
                                
                                
                                
                                
                            }.padding(.vertical, 40)
                            
                            
                            
                            
                         
                            
                            
                        }.frame(width: 300)
                        
                        
                        
                        Spacer()
                    }
                }else{
                    Text("Empty")
                     .font(.title)
                        .padding(.top, 300)

                }
                
            }
  
        
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .navigationTitle("Profile")
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image, name: $imageName, format: $format)
        })
        .onAppear{
            DispatchQueue.main.async {
                userService.runGetUser()
            }
        }
        .alert(item: $userService.userError){error in
            Alert(title: Text("Error"), message: Text(error.messageError))
        }

        
    }
    
    func updateProfile() throws{
        do{
            try update()
        }catch RegisterValidateFieldsErrors.invalidEmail{
            self.userService.userError = UserUniversalErrorsMessage(messageError: RegisterValidateFieldsErrors.invalidEmail.errorMsg)
            
        }
        
    }
    
    func update() throws {
       if !self.email.isEmpty{
        if !AuthValidations.isValidEmail(testStr: self.email){
            throw RegisterValidateFieldsErrors.invalidEmail
        }
        
       }else{
        DispatchQueue.main.async {
        userService.runUpdateProfile(name: username, email: email, image: image, filename: imageName, format: format)
            
        }

        }
   
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
