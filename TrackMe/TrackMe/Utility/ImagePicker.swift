//
//  ImagePicker.swift
//  TrackMe
//
//  Created by Jasmin Rechberger on 20.11.24.
//
import UIKit
import SwiftUI

// Define a struct named ImagePicker that conforms to UIViewControllerRepresentable.
// This allows the struct to be used as a SwiftUI view while representing a UIKit view controller.
struct ImagePicker: UIViewControllerRepresentable {
    
    // Define a variable for setting the source type of the image picker (e.g., camera, photo library).
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    // Use a binding to a UIImage property to pass the selected image back to the parent view.
    @Binding var selectedImage: UIImage
    
    // Use the environment's dismiss action to dismiss the view controller.
    @Environment(\.dismiss) private var dismiss
    
    // This method creates and configures the UIImagePickerController.
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        
        // Initialize an UIImagePickerController instance.
        let imagePicker = UIImagePickerController()
        
        // Set allowsEditing to false, meaning users can't edit the photo in the picker.
        imagePicker.allowsEditing = false
        
        // Set the source type (e.g., camera, photo library).
        imagePicker.sourceType = sourceType
        
        // Assign the delegate to the coordinator for handling image picker events.
        imagePicker.delegate = context.coordinator
        
        return imagePicker
    }
    
    // This method updates the view controller with new data.
    // It's required to conform to UIViewControllerRepresentable but isn't needed here.
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    // This method creates the coordinator object that manages communication between
    // the UIImagePickerController and the SwiftUI view.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Define a nested Coordinator class conforming to UIImagePickerControllerDelegate and UINavigationControllerDelegate.
    // This class handles the selection or cancellation of an image in the picker.
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        // Store a reference to the image picker.
        var parent: ImagePicker
        
        // Initialize the coordinator with the ImagePicker instance.
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        // This method is called when a user selects an image.
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // Extract the selected image from the info dictionary.
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                // Assign the selected image to the binding in the parent view.
                parent.selectedImage = image
            }
            
            // Dismiss the image picker.
            parent.dismiss()
        }
    }
}


