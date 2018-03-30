//
//  InitialAddRemarkCell.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/3/6.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: Cell for addRec table records remark and date.
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////

import UIKit

class InitialAddRemarkCell: UITableViewCell,UITextFieldDelegate{

    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var remarkTF: UITextField!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateTF: UITextField!
    // picker as the inputview of dateTF
    private var picker: UIDatePicker!
    var choosenDate = Date()
    weak var parent: InitialAddRecViewController?
    func setDateTF(){
        picker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.contentView.frame.size.width, height: 216))
        picker.datePickerMode = .date
        picker.backgroundColor = UIColor.white
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton1 = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.setTimeLabel))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.retreatPicker))
        toolBar.setItems([cancelButton, spaceButton, doneButton1], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.dateTF.delegate = self
        self.dateTF.inputView = self.picker
        self.dateTF.inputAccessoryView = toolBar
        self.dateTF.text = NSLocalizedString("Today", comment: "Today String") + " " + self.choosenDate.getMyDateString()
        self.remarkTF.delegate = self
    }
    
    @objc private func setTimeLabel() {
        self.dateTF.text = self.picker.date.getMyDateString()
        self.choosenDate = self.picker.date
        self.dateTF.resignFirstResponder()
    }
    @objc private func retreatPicker() {
        self.dateTF.resignFirstResponder()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField == self.remarkTF) {
            self.parent?.remark = textField.text
        }
        else if (textField == self.dateTF){
            self.parent?.transDate = self.choosenDate
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        if (textField == self.remarkTF) {
            self.parent?.remark = newText
        }
        return true
    }
}
