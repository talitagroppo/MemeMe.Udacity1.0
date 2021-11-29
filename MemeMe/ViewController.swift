//
//  ViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 15/11/2021.
//

import UIKit
import PhotosUI
import NotificationCenter

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageEditor: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var senderImage: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
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
        unsubscribeFromKeyboardNotifications()
    }
    @IBAction func textField(_ sender: UITextField){
        textFieldDidBeginEditing(sender)
        sender.delegate = self
    }
    @IBAction func pickerImage(_ sender: UIBarButtonItem) {
        if (sender == cameraButton){
            sourceController(controller: .camera)
        } else {
            sourceController(controller: .photoLibrary)
        }
    }

    @IBAction func senderImage(_ sender: UIBarButtonItem) {
        let showImage = generateMemedImage()
        guard let image = imageEditor.image else { return }
        let textField = UITextField()
        let controller = UIActivityViewController(activityItems: [image, textField], applicationActivities: nil)
        controller.completionWithItemsHandler = { activit, item, success, error in
            if (success != nil) {
                self.save(showImage)
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
  
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = getKeyboardHeight(notification) * (-1)
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}



