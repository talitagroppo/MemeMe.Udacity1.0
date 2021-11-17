//
//  ViewController.swift
//  MemeMe
//
//  Created by Talita Groppo on 15/11/2021.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageEditor: UIImageView!
    @IBOutlet weak var albunsButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var senderImage: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    
    var itemProviders: [NSItemProvider] = []
    var interactor: IndexingIterator<[NSItemProvider]>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
      
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
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        let identifiars: [String] = results.compactMap(\.assetIdentifier)
        let _ = PHAsset.fetchAssets(withLocalIdentifiers: identifiars, options: nil)
        if let provideImage = results.first?.itemProvider, provideImage.canLoadObject(ofClass: UIImage.self){
        let firstImage = imageEditor.image
        provideImage.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                guard let self = self, let image = image as? UIImage, self.imageEditor.image == firstImage else {return}
                self.imageEditor.image = image
            }

            }
        }
    }
}
