//
//  Date_Extend.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/3/5.
//  Copyright © 2018年 Jue Wang. All rights reserved.
//

import Foundation

extension Date{
    /// Convert the date into format string "yyyyMMdd"
    func getMyDateString() -> String {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyyMMdd"
        return dateFmt.string(from: self)
    }
    
    /**
     Return the string array from date contains [*year*,*month*,*day*]
     
     format: "yyyyMMdd"
     */
    func getYearMonthDay() ->[String]{
        let dateStr = self.getMyDateString()
        let index = dateStr.index(dateStr.startIndex, offsetBy: 6)
        let index2 = dateStr.index(dateStr.startIndex, offsetBy: 4)
        let day = String(dateStr[index...])
        let month = String(dateStr[index2..<index])
        let year = String(dateStr[..<index2])
        return [year,month,day]
    }
    
    /**
     Extract the month and convert it into localize month string
     * English: January
     * Chinese: 一月
     */
    func getMonthString() -> String{
        let months = ["January","Febuary","March","April","May","June","July","August","September","October","November","December"]
        return NSLocalizedString(months[Int(self.getYearMonthDay()[1])! - 1], comment: "Month String")
    }
    
    /**
     - Parameter dateStr: the date string in format "yyyyMMdd"
     
     Passing the date string and return the Date class
     */
    static func getDateFromString(dateStr:String)-> Date {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyyMMdd"
        return fmt.date(from: dateStr)!
    }
}
