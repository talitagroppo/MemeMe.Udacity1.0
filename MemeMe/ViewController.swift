//
//  ViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 15/11/2021.
//

import UIKit
import PhotosUI
import NotificationCenter

class ViewController: UIViewController, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageEditor: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var senderImage: UIBarButtonItem!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    
    var memedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        senderImage.isEnabled = false
        navigationController?.delegate = self
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
        sender.textAlignment = .center
        sender.adjustsFontSizeToFitWidth = true
        sender.minimumFontSize = 10.0
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
        guard let topText = topTextField.text else { return }
        guard let bottomText = bottomTextField.text else { return }
        let controller = UIActivityViewController(activityItems: [image, topText, bottomText], applicationActivities: nil)
        controller.completionWithItemsHandler = {(activityItems, image, topText, bottomText) in
            if (activityItems != nil) {
                self.save(showImage)
            } else {
                print("Check the code")
            }
        }
        controller.popoverPresentationController?.sourceView = self.view
        present(controller, animated: true, completion: nil)
    }
  
    @IBAction func cancel(_ sender: Any) {
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        self.senderImage.isEnabled = false
        self.imageEditor.image = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.topTextField.adjustsFontSizeToFitWidth = true
        let textField: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -1
            ]
        topTextField.defaultTextAttributes = textField
        bottomTextField.defaultTextAttributes = textField
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func sourceController(controller: UIImagePickerController.SourceType){
        let picker = UIImagePickerController()
        picker.sourceType = controller
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    func save(_ memedImage: UIImage) {
        if imageEditor.image != nil && topTextField.text != nil && bottomTextField.text != nil {
        let topText = topTextField.text!
        let bottomText = bottomTextField.text!
        let images = imageEditor.image!
            let meMeme = MemeMe(topTextField: topText, bottomTextField: bottomText, imagemEditor: images, memedImage: memedImage)
        (UIApplication.shared.delegate as! AppDelegate).newData.append(meMeme)
    }
    }
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }

    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    @objc func keyboardWillShow(_ notification:Notification) {
        view.frame.origin.y = getKeyboardHeight(notification) * (-200)
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

extension ViewController: UIImagePickerControllerDelegate {
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
