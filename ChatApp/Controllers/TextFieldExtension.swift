//
//  TextFieldExtension.swift
//  ChatApp
//
//  Created by 大塚周 on 2020/06/22.
//  Copyright © 2020 大塚周. All rights reserved.
//

import UIKit

private var maxLengths = [UITextField: Int]()
private var minLengths = [UITextField: Int]()
extension UITextField {

    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxLengths[self] else {
                return Int.max
            }

            return length
        }
        set {
            maxLengths[self] = newValue
            addTarget(self, action: #selector(limitLength), for: .editingChanged)
        }
    }

    @objc func limitLength(textField: UITextField) {
        guard let prospectiveText = textField.text, prospectiveText.count > maxLength else {
            return
        }

        let selection = selectedTextRange
        let maxCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)

        #if swift(>=4.0)
            text = String(prospectiveText[..<maxCharIndex])
        #else
            text = prospectiveText.substring(to: maxCharIndex)
        #endif

        selectedTextRange = selection
    }
    
    
//    
//    @IBInspectable var minLength: Int {
//        get {
//            guard let length = minLengths[self] else {
//                return Int.min
//            }
//            
//            return length
//        }
//        set {
//            minLengths[self] = newValue
//            
//            addTarget(self, action: #selector(lowestLength), for: .editingChanged)
//        }
//    }
//    @objc func lowestLength(textField: UITextField) {
//        guard let prospectiveText = textField.text, prospectiveText.count < minLength else {
//            return
//        }
//        let selection = selectedTextRange
//        let minCharIndex = prospectiveText.index(prospectiveText.startIndex, offsetBy: minLength)
//        
//        
//        selectedTextRange = selection
//    }
    

}
