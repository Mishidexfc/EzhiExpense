//
//  InitialViewController.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/2/26.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: The initial vc for this app.
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////
import UIKit
import SnapKit
import Charts

class InitialViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    private var initialPanel: InitialStatisticPanelView?
    var initialtable : UITableView?
    private var addButton: UIButton?
    private var detailButton: UIButton?
    private var popView: InitialCellDetailView?
    private var buttonPos : [CGFloat] = [0,0,0,0]
    var userSetting: UserSettings?
    var displayDate = Date() {
        didSet{
            self.drawPlot()
            self.initialtable?.reloadData()
        }
    }
    private var displaySet :[Transaction] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadUserSettings()
        self.initForStatisticPanel()
        self.initForTableView()
        self.initForButtons()
        self.drawPlot()
    }
    
    /// Decode the stored information
    private func loadUserSettings() {
        let recLoader = RecordLoader()
        self.userSetting = recLoader.loadUserSetting()
    }
    
    /// Draw layout for the top part panel
    private func initForStatisticPanel() {
        self.initialPanel = InitialStatisticPanelView.instanceFromNib()
        self.initialPanel?.parent = self
        self.initialPanel?.drawContent()
        self.view.addSubview(self.initialPanel!)
        let screenFrame = UIScreen.main.bounds
        self.initialPanel?.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, screenFrame.height - screenFrame.width * 0.8, 0))
            make.height.equalTo(screenFrame.width * 0.8)
        }
    }
    
    /// Update the datasource and redraw the chart.
    func drawPlot() {
        self.displaySet.removeAll()
        self.initialPanel?.chartView.clear()
        var dataEntrySet: [ChartDataEntry] = []
        var dataEntrySet2: [ChartDataEntry] = []
        var dataEntrySet3: [ChartDataEntry] = []
        var lineSet : [LineChartDataSet] = []
        let dateSet = self.displayDate.getYearMonthDay()
        var endDate = 31
        /// Judging the number of day in the specified month.
        switch dateSet[1] {
        case "02":
            if (Int(dateSet[0])! % 4 != 0) {
                endDate = 28
            }
            else {
                endDate = 29
            }
            break
        case "01","03","05","07","08","10","12":
            endDate = 31
            break
        default:
            endDate = 30
            break
        }
        /// Update the top-center label of year + month, like "2018 January"
        self.initialPanel?.monthLabel.text = dateSet[0] + " " + self.displayDate.getMonthString()
        var earnSum = 0.00, costSum = 0.00
        
        /// Load transactions in the entire month.
        for i in 1...endDate {
            let day = i < 10 ? "0" + String(i) : String(i)
            let fullDate = dateSet[0] + dateSet[1] + day
            var sum = 0.00, sum2 = 0.00
            if let source = self.userSetting?.transactionRecord[fullDate] {
                for temp in source {
                    self.displaySet.append(temp)
                    if (temp.money >= 0.00) {
                        // For earning
                        sum2 += temp.money
                    }
                    else {
                        // For cost
                        sum += -temp.money
                    }
                }
            }
            costSum += sum
            earnSum += sum2
            let dataEntryTempCost = ChartDataEntry(x: Double(i), y: sum)
            let dataEntryTempEarn = ChartDataEntry(x: Double(i), y: sum2)
            let dataEntryTempSum = ChartDataEntry(x: Double(i), y: sum)
            dataEntrySet.append(dataEntryTempCost)
            dataEntrySet2.append(dataEntryTempEarn)
            dataEntrySet3.append(dataEntryTempSum)
        }
        self.initialPanel?.costLabel.text = String(format:"%.2f", costSum)
        self.initialPanel?.earnLabel.text = String(format:"%.2f", earnSum)
        let line = LineChartDataSet(values: dataEntrySet, label: NSLocalizedString("Cost", comment: "Cost"))
        line.colors = [NSUIColor.cyan]
        line.circleColors = [NSUIColor.cyan]
        let line2 = LineChartDataSet(values: dataEntrySet2, label: NSLocalizedString("Earn", comment: "Earn"))
        line2.colors = [NSUIColor.orange]
        line2.circleColors = [NSUIColor.orange]
        lineSet = [line,line2]
        for singleLine in lineSet {
            singleLine.circleRadius = 5
            singleLine.circleHoleRadius = 3
        }
        // If earning does not exist, just rendering the cost line.
        if (earnSum == 0) {
            lineSet = [line]
        }
        self.initialPanel?.chartView.data = LineChartData(dataSets: lineSet)
        let format = NumberFormatter()
        format.numberStyle = .decimal
        self.initialPanel?.chartView.data?.setValueFormatter(DefaultValueFormatter(formatter:format))
        
        self.initialPanel?.chartView.scaleYEnabled = false
        self.initialPanel?.chartView.scaleXEnabled = false
        self.initialPanel?.chartView.xAxis.drawGridLinesEnabled = false
        self.initialPanel?.chartView.xAxis.labelPosition = .bottom
        //self.initialPanel?.chartView.xAxis.enabled = false
        self.initialPanel?.chartView.leftAxis.enabled = false
        self.initialPanel?.chartView.rightAxis.enabled = false
        self.initialPanel?.chartView.leftAxis.axisMinimum = 0
        self.initialPanel?.chartView.rightAxis.axisMinimum = 0
        //self.initialPanel?.chartView.leftAxis.spaceBottom = CGFloat(0.15)
        self.initialPanel?.chartView.chartDescription?.enabled = false
        self.initialPanel?.chartView.setVisibleXRangeMaximum(7)
        self.initialPanel?.chartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5)
    }
    
    /// init the tableview
    private func initForTableView() {
        self.initialtable = UITableView(frame: UIScreen.main.bounds, style: .plain)
        self.initialtable?.delegate = self
        self.initialtable?.dataSource = self
        self.initialtable?.separatorStyle = .none
        let cellNib = UINib(nibName: "InitialTableViewCell", bundle: nil)
        self.initialtable?.register(cellNib, forCellReuseIdentifier: "InitialTVC")
        self.view.addSubview(self.initialtable!)
        let screenFrame = UIScreen.main.bounds
        self.initialtable?.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(screenFrame.width * 0.8, 0, 0, 0))
        }
    }
    
    /// init the bottom-right button
    private func initForButtons() {
        addButton = UIButton()
        addButton?.setImage(UIImage(named: "addIconNormal"), for: .normal)
        addButton?.setImage(UIImage(named:"addIcon"), for: .highlighted)
        self.view.addSubview(addButton!)
        addButton?.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(45)
            make.height.equalTo(45)
            make.bottom.equalTo(-20)
            make.right.equalTo(-20)
        }
        addButton?.addTarget(self, action: #selector(self.addTrans), for: .touchUpInside)
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(self.dragButton(_:)))
        addButton?.addGestureRecognizer(panGes)
        let screenFrame = UIScreen.main.bounds
        self.buttonPos[0] = screenFrame.width * 0.8 + 22.5
        self.buttonPos[1] = screenFrame.height - 22.5
        self.buttonPos[2] = 22.5
        self.buttonPos[3] = screenFrame.width - 22.5
    }
    @objc private func dragButton(_ sender: UIPanGestureRecognizer) {
        if (sender.state == .changed || sender.state == .began) {
            let pos = sender.location(in: self.view)
            if (pos.x >= buttonPos[2] && pos.x <= buttonPos[3] && pos.y >= buttonPos[0] && pos.y <= buttonPos[1]) {
                addButton?.center = pos
            }
        }
//        else if (sender.state == .ended) {
//            let screenFrame = UIScreen.main.bounds
//            
//        }
    }
    @objc private func loadPopView(_ index : Int){
        popView = InitialCellDetailView.loadFromNib()
        let progfileView = InitialTransProfileView.loadFromNib()
        popView?.contentView.addSubview(progfileView)
        progfileView.frame = (popView?.contentView.bounds)!
        progfileView.drawContent(self.displaySet[index])
        popView?.alpha = 0.1
        self.view.addSubview(popView!)
        UIView.animate(withDuration: 0.2){
            self.popView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            self.popView?.alpha = 1
        }
        popView!.snp.makeConstraints{ (make) -> Void in
            make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0))
        }
    }
    /// present the addRec ViewController
    @objc private func addTrans(){
        let newVc = InitialAddRecViewController(nibName: "InitialAddRecViewController", bundle: nil)
        newVc.parentRef = self
        self.present(newVc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displaySet.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.initialtable?.dequeueReusableCell(withIdentifier: "InitialTVC") as? InitialTableViewCell {
            let tempTrans = self.displaySet[indexPath.item]
            cell.priceLabel.text = String(format:"%.2f", (tempTrans.money))
            cell.titleLabel.text = tempTrans.remark != nil && tempTrans.remark != "" ? tempTrans.remark : NSLocalizedString(tempTrans.to, comment: "Cell Title")
            cell.iconImage.image = UIImage(named: (tempTrans.to))
            let dateSet = tempTrans.date.getYearMonthDay()
            cell.dateLabel.text = "\(dateSet[0])/\(dateSet[1])/\(dateSet[2])"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.initialtable?.deselectRow(at: indexPath, animated: true)
        self.loadPopView(indexPath.item)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: NSLocalizedString("Delete", comment: "Delete String")) { (action , index) -> Void in
            let trans = self.displaySet[indexPath.row]
            let tempDateStr = trans.date.getMyDateString()
            /// Finding the corresponding element in transaction
            for i in 0 ..< (self.userSetting?.transactionRecord[tempDateStr]?.count)! {
                if (self.userSetting?.transactionRecord[tempDateStr]![i].index == trans.index) {
                    self.userSetting?.transactionRecord[tempDateStr]?.remove(at: i)
                    self.drawPlot()
                    break
                }
            }
            self.initialtable?.deleteRows(at: [indexPath], with: .left)
            /// Store the record
            let rc = RecordLoader()
            let newTrans = EncodableTrans()
            newTrans.transRecord = self.userSetting?.transactionRecord
            rc.saveRecord(userTrans: newTrans)
        }
        return [deleteAction]
    }
    
}

