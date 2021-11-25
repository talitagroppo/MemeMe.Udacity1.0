//
//  TextField.swift
//  MemeMe
//
//  Created by Talita Groppo on 24/11/2021.
//

import Foundation
import UIKit

extension ViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        topTextField.delegate = self
        bottomTextField.delegate = self
        dismiss(animated: true, completion: nil)
        let textField: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -1
            ]
        topTextField.defaultTextAttributes = textField
        bottomTextField.defaultTextAttributes = textField
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let numberCharacter = textField.text?.count {
            return numberCharacter <= 10
        }
        return (0 != 0)
    }
}
