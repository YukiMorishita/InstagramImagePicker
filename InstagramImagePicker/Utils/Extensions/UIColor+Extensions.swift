//
//  UIColor+Extensions.swift
//  InstagramImagePicker
//
//  Created by admin on 2020/03/26.
//  Copyright © 2020 admin. All rights reserved.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: alpha)
    }
}
