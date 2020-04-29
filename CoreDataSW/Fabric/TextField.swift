//
//  UITextField+Editor.swift
//  CoreDataSW
//
//  Created by Marentilo on 08.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct TextField {
    static func createField(withName: String?, and placeholder: String = Strings.enterValue, tag: Int, delegade: UITextFieldDelegate? = nil) -> UITextField {
        let field = UITextField()
        if let text = withName {
            field.text = text
        }
        field.placeholder = placeholder
        field.backgroundColor = UIColor.white
        field.borderStyle = .roundedRect
        field.delegate = delegade
        field.tag = tag
        return field
    }
    
    static func preferedKeyboard (textField : UITextField, keyboard : UIKeyboardType) {
        textField.keyboardType = keyboard
    }
}
