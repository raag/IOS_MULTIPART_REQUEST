//
//  ContentView.swift
//  MultiPartTest
//
//  Created by Rafael Arzate on 19/07/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var selectedImage: UIImage? = nil
        @State private var showImagePicker: Bool = false

    var body: some View {
        VStack {
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No image selected")
            }
            
            Button(action: {
                showImagePicker = true
            }) {
                Text("Select Image")
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, isPresented: $showImagePicker)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
