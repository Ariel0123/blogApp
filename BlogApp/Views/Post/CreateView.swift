//
//  CreateView.swift
//  BlogApp
//
//  Created by Ariel Ortiz on 8/12/21.
//

import SwiftUI


struct CreateView: View {

    @EnvironmentObject var postService: PostServices
    
   // @Binding var tabSelection: Int
    
    @State var showImagePicker: Bool = false
    @State var image = UIImage()
    @State var name = ""
    @State var format = ""
    
    @State var title = ""
    @State var description = ""
    
    let minHeight: CGFloat = 400
    @State private var textViewHeight: CGFloat?
    
    var body: some View {
        
       
        VStack{
            HStack{
                Button("Open Image", action: {
                    showImagePicker.toggle()
                        
                })
                Spacer()
                Button("Create", action: {
                    do{
                        try self.runPost()
                    }catch{
                        print(error)
                    }
                        
                })
            }.padding()

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
        .navigationTitle("New Post")
        .sheet(isPresented: $showImagePicker, content: {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $image, name: $name, format: $format)
        })
        .alert(item: $postService.postError){ message in
            Alert(title: Text("Error"), message: Text(message.messageError))
        }
        
    }
    
    private func textDidChange(_ textView: UITextView) {
            self.textViewHeight = max(textView.contentSize.height, minHeight)
        }
    

    
    func runPost() throws {
        
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
                postService.runCreatePost(title: title, description: description, image: image, name: name, format: format)
                
                        self.clearFiels()
                        postService.tabSelection = 1
              
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

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
            .environmentObject(PostServices())
    }
}

