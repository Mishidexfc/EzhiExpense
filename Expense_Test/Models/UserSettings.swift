//
//  UserSettings.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/3/2.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: users' custome settings class, holding a mediator.
//  Updates:
//  20180307    first version, currentRoles are not codable yet.
////////////////////////////////////////////////////////////////////
import Foundation
class UserSettings:Codable{
    /// roles dictionary, mainly used in addRec view
    var currentRoles: [Roles:[String]] = [.Payer:["Me"],
                                          .Payment: ["Default","Cash","Debit","Credit","Alipay","Wepay","Paypal","Online","Check"],
                                          .Payee:["Default","Food","Supermarket","Shop", "Traffic", "Transfer","Movie","Rent","Hospital","Finance","Gift"]]
    /// (Codable)Store the transaction record
    var transactionRecord: [String:[Transaction]] = [:]
    /// mediator instance
    var mediator: RoleMediator?
    
    init(){
        let mediator = RoleMediator(roles: [])
        /// init the default roles
        for temp in currentRoles {
            for tempA in temp.value {
                guard mediator.registerNewRole(name: tempA, role: temp.key) else {
                    print("false to create new payer.")
                    return
                }
            }
        }
        self.mediator = mediator
        self.mediator?.parentUserSetting = self
    }
}
