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
        start()
        navigationController?.delegate = self
        textFields()
        }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
        controller.completionWithItemsHandler = {(activity, completed, items, error) in
            if completed {
            self.save(showImage)
            } else {
                self.start()
            }
        }
        controller.popoverPresentationController?.sourceView = self.view
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancel(_ sender: Any) {
        start()
    }
    
    func start() {
        self.topTextField.text = "TOP"
        self.bottomTextField.text = "BOTTOM"
        self.senderImage.isEnabled = false
        self.imageEditor.image = nil
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let textFieldAttributes: [NSAttributedString.Key: Any] = [
          .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            .strokeWidth: -3.0
        ]
        textField.defaultTextAttributes = textFieldAttributes
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
        UIImageWriteToSavedPhotosAlbum(memedImage, nil, nil, nil)
    }
    
        func textFields(){
        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")

    }
    
    func setupTextField(_ textField: UITextField, text: String){
        topTextField.delegate = self
        topTextField.textAlignment = .center
        topTextField.adjustsFontSizeToFitWidth = true
        topTextField.minimumFontSize = 10.0
        
        bottomTextField.delegate = self
        bottomTextField.textAlignment = .center
        bottomTextField.adjustsFontSizeToFitWidth = true
        bottomTextField.minimumFontSize = 10.0
    }
    
        func generateMemedImage() -> UIImage {
        hideAndShowBars(true)
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        hideAndShowBars(false)
        return memedImage
    }
    func  hideAndShowBars(_ hide: Bool) {
        if !hide {
            toolBarTop.isHidden = false
            toolBarBottom.isHidden = false
        } else {
            toolBarTop.isHidden = true
            toolBarBottom.isHidden = true
        }
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
            if bottomTextField.isFirstResponder{
        view.frame.origin.y = -getKeyboardHeight(notification)
        } else{
        topTextField.frame.origin.y = getKeyboardHeight(notification)
        }
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

