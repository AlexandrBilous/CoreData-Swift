//
//  UILabel+Text.swift
//  CoreDataSW
//
//  Created by Marentilo on 08.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

struct Label {
    static func makeLabel(title: String? = nil, textColor : UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)) -> UILabel {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = title
        label.textColor = textColor
        return label
    }

    
}
