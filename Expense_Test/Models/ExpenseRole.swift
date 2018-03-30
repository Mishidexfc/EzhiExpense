//
//  ExpenseRole.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/2/26.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: role class for each user, payment or payee, contains name, role type, and id (unique in each mediator)
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////
import Foundation
/// enum for role type
enum Roles : Int,Codable{
    case Payer = 0
    case Payment = 1
    case Payee = 2
}

class ExpenseRole:Codable{
    var name:String = ""
    var role:Roles = .Payer
    // unique role id
    private var roleId:Int = 0
    
    init(name:String, role:Roles, roleId:Int, mediator: RoleMediator) {
        self.name = name
        self.role = role
        self.roleId = roleId
    }
    
    func getRoleId() -> Int{
        return self.roleId
    }

}
