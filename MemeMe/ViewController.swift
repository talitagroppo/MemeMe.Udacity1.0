//
//  ViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 15/11/2021.
//

import UIKit
import PhotosUI
import NotificationCenter

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var topText = String()
    var bottomText = String()

    @IBOutlet weak var imageEditor: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var senderImage: UIBarButtonItem!
    
    var itemProviders: [NSItemProvider] = []
    var interactor: IndexingIterator<[NSItemProvider]>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
        imagePicker.sourceType = .camera
           present(imagePicker, animated: true, completion: nil)
       }
    @IBAction func pickAnLibraryImage(_ sender: Any) {
        let photoLibrary = PHPhotoLibrary.shared()
        var configuration = PHPickerConfiguration(photoLibrary: photoLibrary)
        configuration.selectionLimit = 0
//        configuration.filter = .images
//        configuration.filter = .any(of: [.videos, .livePhotos])
        let pickerImage = PHPickerViewController(configuration: configuration)
        pickerImage.delegate = self
        present(pickerImage, animated: true, completion: nil)
    }
    @IBAction func senderImage(_ sender: Any) {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        let identifiars: [String] = results.compactMap(\.assetIdentifier)
        let _ = PHAsset.fetchAssets(withLocalIdentifiers: identifiars, options: nil)
        if let provideImage = results.first?.itemProvider,
           provideImage.canLoadObject(ofClass: UIImage.self){
        let firstImage = imageEditor.image
            provideImage.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                guard let self = self, let image = image as? UIImage, self.imageEditor.image == firstImage else {return}
                self.imageEditor.image = image
                self.topTextField.text? = self.topText
                self.bottomTextField.text? = self.bottomText
                self.hidesBottomBarWhenPushed = true
            }
            }
        }
    }
    func generateMemedImage() -> UIImage{
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
}
extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let topText = UITextField()
        let bottomText = UITextField()
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  15
        ]
        let newTextTop = topText
        let newTextBottom = bottomText
        newTextTop.defaultTextAttributes = memeTextAttributes
        newTextBottom.defaultTextAttributes = memeTextAttributes
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIWindow.keyboardWillShowNotification, object: nil)
    }
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
    }
//    func save() {
//        let _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageEditor.image!)
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
     let topText = UITextField()
     let bottomText = UITextField()
     let memeTextAttributes: [NSAttributedString.Key: Any] = [
         NSAttributedString.Key.strokeColor: UIColor.white,
         NSAttributedString.Key.foregroundColor: UIColor.black,
         NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
         NSAttributedString.Key.strokeWidth:  15
     ]
     let newTextTop = topText
     let newTextBottom = bottomText
     newTextTop.defaultTextAttributes = memeTextAttributes
     newTextBottom.defaultTextAttributes = memeTextAttributes
 }
}
//class Meme{
//    var topText: String = "TopText"
//    var bottomText: String = "BottomText"
//    let originalImage: UIImage
//
//    init(topText: String, bottomText: String, originalImage: UIImage) {
//        self.topText = topText
//        self.bottomText = bottomText
//        self.originalImage = originalImage
//    }
//}
