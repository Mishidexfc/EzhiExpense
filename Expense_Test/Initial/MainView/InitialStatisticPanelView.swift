//
//  InitialStatisticPanelView.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/2/26.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: The top panel of initial vc.
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////

import UIKit
import Charts
class InitialStatisticPanelView: UIView {
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var TopBarView: UIView!
    @IBOutlet weak var SummaryPanel: UIView!
    @IBOutlet weak var costLabel: UILabel!
    @IBOutlet weak var earnLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var costTitleLabel: UILabel!
    @IBOutlet weak var earnTitleLabel: UILabel!
    weak var parent:InitialViewController?
    
    @IBOutlet weak var leftArrow: UIButton!
    @IBOutlet weak var rightArrow: UIButton!
    
    func drawContent() {
        self.backgroundColor = UIColor(rgb: 0x8BE6C7)
        self.TopBarView.backgroundColor = UIColor(rgb: 0x8BE6C7)
        self.SummaryPanel.backgroundColor = UIColor(rgb: 0x8BE6C7)
        self.costTitleLabel.text = NSLocalizedString("Cost", comment: "Cost Title")
        self.earnTitleLabel.text = NSLocalizedString("Earn", comment: "Earn Title")
    }
    
    
    
    /// Tap the left arrow
    @IBAction func goPrevMonth(_ sender: UIButton) {
        var dateSet = self.parent?.displayDate.getYearMonthDay()
        var year = Int(dateSet![0])!, month = Int(dateSet![1])!
        if (month == 1) {
            month = 12
            year -= 1
        }
        else {
            month -= 1
        }
        let dateStr = String(year) + (month < 10 ? "0" + String(month): String(month)) + "01"
        self.parent?.displayDate = Date.getDateFromString(dateStr: dateStr)
        self.parent?.drawPlot()
        self.parent?.initialtable?.reloadData()
    }
    
    // Tap the right arrow
    @IBAction func goNextMonth(_ sender: UIButton) {
        var dateSet = self.parent?.displayDate.getYearMonthDay()
        var year = Int(dateSet![0])!, month = Int(dateSet![1])!
        if (month == 12) {
            month = 1
            year += 1
        }
        else {
            month += 1
        }
        let dateStr = String(year) + (month < 10 ? "0" + String(month): String(month)) + "01"
        self.parent?.displayDate = Date.getDateFromString(dateStr: dateStr)
        self.parent?.drawPlot()
        self.parent?.initialtable?.reloadData()
    }
    
    class func instanceFromNib() -> InitialStatisticPanelView {
        return UINib(nibName: "InitialStatisticPanelView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! InitialStatisticPanelView
    }
}
