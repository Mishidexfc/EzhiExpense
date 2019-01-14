//
//  InitialTransProfileView.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/4/15.
//  Copyright © 2018年 Jue Wang. All rights reserved.
//

import Foundation
import UIKit

class InitialTransProfileView: UIView {
    @IBOutlet weak var payeeImage: UIImageView!
    @IBOutlet weak var payeeLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var payerLabel: UILabel!
    @IBOutlet weak var payerImage: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var paymentImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateNumLabel: UILabel!
    @IBOutlet weak var remarkLabel: UILabel!
    @IBOutlet weak var remarkTF: UITextView!
    class func loadFromNib() -> InitialTransProfileView {
        return Bundle.main.loadNibNamed("InitialTransProfileView", owner: nil, options: nil)?[0] as! InitialTransProfileView
    }
    func drawContent(_ trans: Transaction){
        payeeImage.image = UIImage(named: trans.to)
        payeeLabel.text = NSLocalizedString(trans.to, comment: "Payee")
        moneyLabel.text = String(trans.money)
        if (trans.money > 0) {
            moneyLabel.text = "+" + moneyLabel.text!
        }
        payerLabel.text = NSLocalizedString(trans.from, comment: "Payer")
        payerImage.image = UIImage(named: trans.from)
        paymentLabel.text = NSLocalizedString("Payment", comment: "Payment")
        paymentImage.image = UIImage(named: trans.by)
        dateLabel.text = NSLocalizedString("Date", comment: "Date label")
        dateNumLabel.text = trans.date.getMyDateString()
        remarkLabel.text = NSLocalizedString("Remark", comment: "Remark label")
        if trans.remark != nil {
            remarkTF.text = trans.remark!
        }
    }
}
