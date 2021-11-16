//
//  ViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 15/11/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageView: UIImage?
    
    @IBOutlet weak var imageEditor: UIImageView!
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var senderImage: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
        imagePicker.sourceType = .camera
           present(imagePicker, animated: true, completion: nil)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
       }
    @IBAction func senderImage(_ sender: Any) {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func topText(_ sender: Any) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.white,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  15
        ]
        let newText = UITextField()
        newText.defaultTextAttributes = memeTextAttributes
 
    }
}

