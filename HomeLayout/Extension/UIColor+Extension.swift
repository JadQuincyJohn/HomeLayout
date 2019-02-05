//
//  UIColor+Extension.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 05/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(_ r: CGFloat,_ g: CGFloat,_ b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
