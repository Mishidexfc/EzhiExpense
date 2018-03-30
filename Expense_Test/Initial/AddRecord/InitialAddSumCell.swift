//
//  InitialAddSumCell.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/3/5.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: Cell for addRec table contains a textfield and a segment contorll.
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////

import UIKit

class InitialAddSumCell: UITableViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var decimalTF: UITextField!
    weak var parent: InitialAddRecViewController?
    func drawContent() {
        self.decimalTF.delegate = self
    }
    
    // Delegate for auto record the value
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        self.parent?.money = Double(newText)
        return true
    }
    // Delegate for auto record the value
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.parent?.money = self.decimalTF.text == nil || self.decimalTF.text == "" ? 0.00 : Double(self.decimalTF.text!)
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.parent?.costOrEarn = true
        case 1:
            self.parent?.costOrEarn = false
        default:
            break
        }
    }
    
}
