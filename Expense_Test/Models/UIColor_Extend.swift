//
//  UIColor_Extend.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/2/27.
//  Copyright © 2018年 Jue Wang. All rights reserved.
//

import Foundation
import UIKit
extension UIColor {
    /// init the uicolor by enter the hex UInt, convert into RGB
    convenience init(rgb: UInt) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
