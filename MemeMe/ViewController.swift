//
//  ViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 15/11/2021.
//

import UIKit
import PhotosUI
import NotificationCenter

class ViewController: UIViewController, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var imageEditor: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var senderImage: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var toolBarButtom: UIToolbar!
    @IBOutlet weak var toolBarTop: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        senderImage.isEnabled = false

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeToKeyboardNotifications()
    }
    
    @IBAction func textField(_ sender: UITextField) {
        
    }
    @IBAction func pickImage(_ sender: Any) {
        let cameraButton = UIImagePickerController()
        cameraButton.delegate = self
        cameraButton.sourceType = .camera
        present(cameraButton, animated: true, completion: nil)
        let photoLibrary = UIImagePickerController()
        photoLibrary.delegate = self
        photoLibrary.sourceType = .photoLibrary
        present(photoLibrary, animated: true, completion: nil)
    }
  
    @IBAction func senderImage(_ sender: UIButton) {
        guard let image = imageEditor.image else { return }
        let textField = UITextField()
        let controller = UIActivityViewController(activityItems: [image, textField], applicationActivities: nil)
        controller.completionWithItemsHandler = { activit, item, success, error in
            if (success != nil) {
                self.save()
            } else {
                print("Check the code")
            }
        }
        controller.popoverPresentationController?.sourceView = self.view
        present(controller, animated: true, completion: nil)
    }
  
    @IBAction func cancel(_ sender: Any) {
        self.topTextField.text = "Top"
        self.bottomTextField.text = "Bottom"
        self.senderImage.isEnabled = false
        self.imageEditor.image = nil
    }
    func save() {
        let topText = "Top"
        let bottomText = "Bottom"
        let images = imageEditor.image!
    let meMeme = MemeMe(topTextField: topText, bottomTextField: bottomText, imagemEditor: images)
        (UIApplication.shared.delegate as! AppDelegate).newData.append(meMeme)
    }
    func generateMemedImage() -> UIImage {
        toolBarTop.isHidden = true
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        toolBarTop.isHidden = false

        return memedImage
    }
}



