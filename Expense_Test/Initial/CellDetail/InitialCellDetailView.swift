//
//  InitialCellDetailView.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/4/15.
//  Copyright © 2018年 Jue Wang. All rights reserved.
//

import Foundation
import UIKit

class InitialCellDetailView: UIView,PopScene {
    @IBOutlet weak var contentView: UIView!
    @IBAction func tapExitButton(_ sender: UIButton) {
        self.dismissPop()
    }
    func dismissPop() {
        self.removeFromSuperview()
    }
    class func loadFromNib() -> InitialCellDetailView {
        return Bundle.main.loadNibNamed("InitialCellDetailView", owner: nil, options: nil)?[0] as! InitialCellDetailView
    }
}
