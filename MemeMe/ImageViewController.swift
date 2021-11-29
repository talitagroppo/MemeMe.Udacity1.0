//
//  ImageViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 29/11/2021.
//

import Foundation
import UIKit

extension ViewController: UIImagePickerControllerDelegate{
    func sourceController(controller: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = controller
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func save(_ saveImage: UIImage) {
        let topText = "Top"
        let bottomText = "Bottom"
        let images = imageEditor.image!
    let meMeme = MemeMe(topTextField: topText, bottomTextField: bottomText, imagemEditor: images)
        (UIApplication.shared.delegate as! AppDelegate).newData.append(meMeme)
    }
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return memedImage
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        senderImage.isEnabled = true
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                   imageEditor.image = image
               }
               dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
