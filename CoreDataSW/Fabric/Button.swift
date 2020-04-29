//
//  UIButtow+Image.swift
//  CoreDataSW
//
//  Created by Marentilo on 08.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct Button {
    static func newButton(withTitle title: String?, andImage image: UIImage?, tag: Int) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}
