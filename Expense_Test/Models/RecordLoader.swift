//
//  RecordLoader.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/3/6.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: class for encoding and decoding.
//  Updates:
//  20180307    first version, currently only stores the transaction information
////////////////////////////////////////////////////////////////////

import Foundation
class RecordLoader{
    /// document path plus the filename "userSetting"
    private let fullPath = NSHomeDirectory() + "/Documents/userSetting"
    
    func loadUserSetting()->UserSettings {
        let newUser = UserSettings()
        let mediator = RoleMediator(roles: [])
        newUser.mediator = mediator
        /// If the stored file exists
        if let myData = UserDefaults.standard.value(forKey: "userSettings") as? Data {
            let decoder = JSONDecoder()
            if let objectsDecoded = try? decoder.decode(EncodableTrans.self, from: myData) {
                newUser.transactionRecord = objectsDecoded.transRecord!
            }
        }
        for temp in newUser.currentRoles {
            for tempA in temp.value {
                guard (newUser.mediator?.registerNewRole(name: tempA, role: temp.key))! else {
                    // print("false to create new payer.")
                    continue
                }
            }
        }
        newUser.mediator?.parentUserSetting = newUser
        return newUser
    }
    
    func saveRecord(userTrans:EncodableTrans) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(userTrans) {
            UserDefaults.standard.set(encoded, forKey: "userSettings")
        }
        
    }
}
