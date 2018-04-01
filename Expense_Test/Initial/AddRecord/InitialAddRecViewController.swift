//
//  InitialAddRecViewController.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/2/28.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: The view controller for adding new transaction
//  Updates:
//  20180307    First version
//  20180331    Fix the bug that the keyboard covers the remark textfield
////////////////////////////////////////////////////////////////////

import UIKit
import SnapKit
class InitialAddRecViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    weak var parentRef: InitialViewController?
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var customTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    // deciding the type of the transaction
    var costOrEarn:Bool = true
    var fromName: String? = "Me"
    var toName: String? = "Default"
    var by: String? = "Default"
    var money: Double? = 0.00
    var transDate = Date()
    var remark:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.drawContent()
        self.customTableView.keyboardDismissMode = .onDrag
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(note:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(note:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(note: NSNotification) {
        if let keyboardSize = (note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            self.customTableView.snp.updateConstraints { (make) -> Void in
                make.bottom.equalTo(0).offset(-keyboardSize.height)
            }
        }
    }

    @objc func keyboardWillHide(note: NSNotification) {
        self.customTableView.snp.updateConstraints{ (make) -> Void in
            make.bottom.equalTo(0)
        }
    }
    /// Cancel
    @IBAction func cancelAddition(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /// Save the transaction and dismiss the controller
    @IBAction func saveRecord(_ sender: UIButton) {
        guard let mediator = self.parentRef?.userSetting?.mediator,(self.fromName != nil), (self.toName != nil), (self.by != nil), (self.money != nil) else{
            return
        }
        self.money = self.costOrEarn ? -self.money! : self.money
        if mediator.transfer(from: self.fromName!, to: self.toName!, by: self.by!, money: self.money!, date: transDate,remark: self.remark) {
            self.parentRef?.displayDate = transDate
            self.parentRef?.drawPlot()
            self.parentRef?.initialtable?.reloadData()
            // Save record
            let rc = RecordLoader()
            let newTrans = EncodableTrans()
            newTrans.transRecord = self.parentRef?.userSetting?.transactionRecord
            rc.saveRecord(userTrans: newTrans)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            return //error happens
        }
    }
    
    private func drawContent() {
        self.titleLabel.text = NSLocalizedString("Add your transaction", comment: "Add your transaction")
        self.cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Cancel"), for: .normal)
        self.saveButton.setTitle(NSLocalizedString("Save", comment: "Save"), for: .normal) 
        self.customTableView.delegate = self
        self.customTableView.dataSource = self
        let myNib = UINib(nibName: "InitialAddTableViewImageCell", bundle: nil)
        self.customTableView.register(myNib, forCellReuseIdentifier: "AddCell")
        let myNib2 = UINib(nibName: "InitialAddSumCell", bundle: nil)
        self.customTableView.register(myNib2, forCellReuseIdentifier: "InputCell")
        let myNib3 = UINib(nibName: "InitialAddHeaderCell", bundle: nil)
        self.customTableView.register(myNib3, forCellReuseIdentifier: "HeaderCell")
        let myNib4 = UINib(nibName: "InitialAddRemarkCell", bundle: nil)
        self.customTableView.register(myNib4, forCellReuseIdentifier: "RemarkCell")
        //InitialAddSumCell
        self.customTableView.snp.makeConstraints{ (make)->Void in
            make.edges.equalTo(UIEdgeInsetsMake(70, 0, 0, 0))
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 40
        case 4:
            return 100
        default:
            if (indexPath.row == 0) {
                return 40
            }
        }
        /// Judging the width of screen
        return (self.parentRef?.userSetting?.currentRoles[Roles(rawValue: (indexPath.section - 1))!]?.count)! * 80 > Int(UIScreen.main.bounds.width) ? 200 : 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 || section == 4 ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = self.customTableView.dequeueReusableCell(withIdentifier: "InputCell") as! InitialAddSumCell
            cell.selectionStyle = .none
            cell.decimalTF.placeholder = NSLocalizedString("InputSum", comment: "Input sum place holder")
            cell.segment.setTitle(NSLocalizedString("Cost", comment: "Segment 0 title"), forSegmentAt: 0)
            cell.segment.setTitle(NSLocalizedString("Earn", comment: "Segment 1 title"), forSegmentAt: 1)
            cell.parent = self
            cell.drawContent()
            return cell
        case 4:
            let cell = self.customTableView.dequeueReusableCell(withIdentifier: "RemarkCell") as! InitialAddRemarkCell
            cell.remarkLabel.text = NSLocalizedString("Remark", comment: "Remark String")
            cell.remarkTF.placeholder = NSLocalizedString("InputOptional", comment: "Optional Remark placeholder")
            cell.dateLabel.text = NSLocalizedString("Date", comment: "Date String")
            cell.setDateTF()
            cell.parent = self
            cell.selectionStyle = .none
            return cell
        default:
            if (indexPath.row == 0) {
                let cell = self.customTableView.dequeueReusableCell(withIdentifier: "HeaderCell") as! InitialAddHeaderCell
                switch indexPath.section {
                case 1:
                    cell.headerLabel.text = NSLocalizedString("Choose payer", comment: "Choose payer")
                case 2:
                    cell.headerLabel.text = NSLocalizedString("Choose payment", comment: "Choose payment")
                case 3:
                    cell.headerLabel.text = NSLocalizedString("Choose payee", comment: "Choose payee")
                default:
                    break
                }
                cell.selectionStyle = .none
                return cell
            }
            let cell = self.customTableView.dequeueReusableCell(withIdentifier: "AddCell") as! InitialAddTableViewImageCell
            switch indexPath.section {
            case 1:
                cell.myRole = .Payer
            case 2:
                cell.myRole = .Payment
            case 3:
                cell.myRole = .Payee
            default:
                break
            }
            cell.selectionStyle = .none
            cell.parent = self
            cell.imageCollection.allowsMultipleSelection = false
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = self.customTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InitialAddSumCell {
            cell.decimalTF.resignFirstResponder()
        }
        if let cell = self.customTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? InitialAddRemarkCell {
            cell.remarkTF.resignFirstResponder()
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let cell = self.customTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InitialAddSumCell {
                cell.decimalTF.resignFirstResponder()
        }
        if let cell = self.customTableView.cellForRow(at: IndexPath(row: 0, section: 4)) as? InitialAddRemarkCell {
            cell.remarkTF.resignFirstResponder()
        }
    }
}
