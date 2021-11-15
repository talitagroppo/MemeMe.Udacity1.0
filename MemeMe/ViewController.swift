//
//  ViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 15/11/2021.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var image: UIImage?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var senderImage: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func pickerImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
        
    }
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
           let imagePicker = UIImagePickerController()
           imagePicker.delegate = self
        imagePicker.sourceType = .camera
           present(imagePicker, animated: true, completion: nil)
       }
    @IBAction func senderImage(_ sender: Any) {
        let image = UIImage()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        present(controller, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        if let image = self.image {
            self.imageView.image = UIImage(named: "d\(image)")
        } else {
            self.imageView.image = nil
        }
        self.imageView.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(withDuration: 1.0) {
            self.imageView.alpha = 1
            
        }
    }

}

