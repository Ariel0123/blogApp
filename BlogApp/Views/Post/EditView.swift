//
//  EditView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/15/21.
//

import SwiftUI

struct EditView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var postService: PostServices
    @EnvironmentObject var selectedPost: CurrentPostSelected

    
    @State var showImagePicker: Bool = false
    @State var image = UIImage()
    @State var name = ""
    @State var format = ""
    
    @State var title = ""
    @State var description = ""
    

    let minHeight: CGFloat = 300
    @State private var textViewHeight: CGFloat?
  
    
    var body: some View {
        

        VStack {
            
          
      
            HStack {
                Text("Update post")
                    .font(.headline)
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                })
              
                
            }.padding()

            
            HStack{
                Button("Open Image", action: {
                    showImagePicker.toggle()
                        
                })
                Spacer()
                Button("Update", action: {
                    do{
                        try self.runUpdate()
                    }catch{
                        print(error)
                    }
                        
                })
            }.padding(.horizontal)
            
            ScrollView(showsIndicators: false){

            
            if (image.cgImage != nil){
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .padding(.bottom)
            }
        
            TextField("Title", text: $title)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(20)


            
            WrappedTextView(text: $description, textDidChange: self.textDidChange)
                .padding()
                .background(Color.gray.opacity(0.1))
               .cornerRadius(20)
                    .frame(height: textViewHeight ?? minHeight)
           
            
          
            
            
            
            Spacer()
            
        }.padding()
        }
        
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image, name: $name, format: $format)
        })
        .alert(item: $postService.postError){ message in
            Alert(title: Text("Error"), message: Text(message.messageError))
        }
        .onAppear{
            if !selectedPost.postCurrent!.title.isEmpty{
                self.title = selectedPost.postCurrent!.title
                self.description = selectedPost.postCurrent!.description
                
                let url = URL(string: "http://localhost:4000/"+selectedPost.postCurrent!.image)! as URL
                if let imageData: NSData = NSData(contentsOf: url) {
                    image = UIImage(data: imageData as Data)!
                }
                
            }
        }
        
        
}
    
    private func textDidChange(_ textView: UITextView) {
            self.textViewHeight = max(textView.contentSize.height, minHeight)
        }
    
    func runUpdate() throws {
        
        do{
            try checkFields()
            
        }catch PostValidateFieldsErrors.title{
            self.postService.postError = PostUniversalErrorsMessage(messageError: PostValidateFieldsErrors.title.errorMsg)
            
        }catch PostValidateFieldsErrors.description{
            self.postService.postError = PostUniversalErrorsMessage(messageError: PostValidateFieldsErrors.description.errorMsg)

        }catch PostValidateFieldsErrors.image{
            self.postService.postError = PostUniversalErrorsMessage(messageError: PostValidateFieldsErrors.image.errorMsg)

        }
    }
    
    
    func checkFields() throws {
        
        if self.title.isEmpty{
            throw PostValidateFieldsErrors.title
            
        }else if self.description.isEmpty{
            throw PostValidateFieldsErrors.description
            
        }else if (image.cgImage == nil){
            throw PostValidateFieldsErrors.image
            
        }else{
                   
            if !title.isEmpty && !description.isEmpty && (image.cgImage != nil){
                self.postService.runUpdatePost(id: selectedPost.postCurrent!._id, title: title, description: description, image: image, name: name, format: format)
                
                self.clearFiels()
                
             
                        presentationMode.wrappedValue.dismiss()
              
     
                
            }
        }
    }
    
    
    func clearFiels(){
        self.title = ""
        self.description = ""
        self.image = UIImage()
        self.name = ""
        self.format = ""
    }
    
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView()
    }
}
