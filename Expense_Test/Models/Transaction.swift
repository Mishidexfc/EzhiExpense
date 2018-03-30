//
//  Transaction.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/2/28.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: class for transaction, hold necessary information and is codable.
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////

import Foundation
class Transaction:Codable{
    var from: String!
    var to: String!
    var by:String!
    var money: Double!
    var date : Date!
    var remark: String?
    /// unique index in dictionary, for convenient removing the cell in table view.
    var index: Int!
    
    init(from:ExpenseRole, to:ExpenseRole,by: ExpenseRole,money: Double, date: Date, remark: String?,index: Int) {
        self.from = from.name
        self.to = to.name
        self.by = by.name
        self.money = money
        self.date = date
        if (remark != nil) {
            self.remark = remark
        }
        self.index = index
    }
}

