//
//  RoleMediator.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/2/28.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: Repository for operations, storing the transaction into the user setting.Hold by usersettings.
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////

import Foundation
class RoleMediator:Codable{
    private var idMax: Int = 0
    var refer : [Roles:[String: ExpenseRole]] = [:] {
        didSet{
            self.idMax = Int(self.refer.count - 1)
        }
    }
    /// the parent, nil if no instance for usersetting.
    var parentUserSetting: UserSettings?
    // For future use, the mediator can initialize by accepting role arrays.
    init(roles: [ExpenseRole]) {
        self.refer = [.Payee:[:],.Payer:[:],.Payment:[:]]
        for ro in roles {
            self.refer[ro.role]![ro.name] = ro
        }
        self.idMax = Int(self.refer.count - 1)
    }
    /**
    - Parameter from: the payer who pays or receives the money, mostly the role is the user himself/herself.
    - Parameter to: the payee or the purpose
    - Parameter by: payment method
    - Parameter money: money in Double
    - Parameter date: Default is today(now)
    - Parameter remark: nil if no input from user
    
    Handle the transaction values from addRec
     */
    func transfer(from: String, to: String,by: String, money: Double, date:Date ,remark: String?)-> Bool{
        guard let start = self.refer[.Payer]![from], let target = self.refer[.Payee]![to], let payment = self.refer[.Payment]![by] else{
            return false
        }
        let index = self.parentUserSetting?.transactionRecord[date.getMyDateString()] == nil ? 0 : self.parentUserSetting?.transactionRecord[date.getMyDateString()]?.count
        let trans = Transaction(from: start, to: target, by: payment, money: money, date: date, remark: remark, index: index!)
        let myDate = trans.date.getMyDateString()
        if (self.parentUserSetting?.transactionRecord[myDate] == nil) {
            self.parentUserSetting?.transactionRecord[myDate] = []
        }
        self.parentUserSetting?.transactionRecord[myDate]?.append(trans)
        return true
    }
    
    /// registerNewRole can be used for customize the payment or other roles.
    func registerNewRole(name: String,role: Roles)-> Bool{
        guard (self.refer[role]![name] == nil) else{
            return false
        }
        let newRole = ExpenseRole(name: name, role: role, roleId: Int(self.idMax + 1), mediator: self)
        self.refer[role]![name] = newRole
        return true
    }
    
    /// Future use, this function can hold a unique id and change a user's name with all the transactions.
    private func updateName(oldName: String, newName: String, role:Roles) -> Bool{
        guard (self.refer[role]![newName] == nil) else{
            return false
        }
        self.refer[role]![newName] = self.refer[role]![oldName]
        self.refer[role]![oldName] = nil
        return true
    }
}
