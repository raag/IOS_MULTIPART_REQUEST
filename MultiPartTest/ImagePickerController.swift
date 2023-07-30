//
//  ImagePickerController.swift
//  MultiPartTest
//
//  Created by Rafael Arzate on 19/07/23.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var isPresented: Bool

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: UIImage?
        @Binding var isPresented: Bool

        init(selectedImage: Binding<UIImage?>, isPresented: Binding<Bool>) {
            _selectedImage = selectedImage
            _isPresented = isPresented
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                self.selectedImage = selectedImage
                Task {
                    await uploadFile( selectedImage )
                }
            }
            isPresented = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isPresented = false
        }
        
        
        func uploadFile(_ image: UIImage) async {
            var multipart = MultipartRequest()
            for field in [
                "firstName": "John",
                "lastName": "Doe"
            ] {
                multipart.add(key: field.key, value: field.value)
            }
            
            guard let imageData = image.pngData() else {
                print("Image not found")
                return
            }
            
            multipart.add(
                key: "file",
                fileName: "test.png",
                fileMimeType: "image/png",
                fileData: imageData
            )
            
            /// Create a regular HTTP URL request & use multipart components
            let url = URL(string: "http://localhost:3000")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
            request.httpBody = multipart.httpBody
            
            do {
                let (data1, response) = try await  URLSession.shared.data(for: request)
                print((response as! HTTPURLResponse).statusCode)
                print(String(data: data1, encoding: .utf8)!)
            } catch {
                print ("Error")
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(selectedImage: $selectedImage, isPresented: $isPresented)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }
    
    
}
