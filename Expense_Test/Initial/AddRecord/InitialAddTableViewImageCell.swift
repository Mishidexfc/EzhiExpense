//
//  InitialAddTableViewImageCell.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/3/3.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: The cell contains the collection view.
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////

import UIKit

class InitialAddTableViewImageCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    var myRole: Roles = .Payer
    @IBOutlet weak var imageCollection: UICollectionView!
    weak var parent: InitialAddRecViewController?
    private var isLoad = false
    private var titleSet: [String] = []
    private var selectedItem: Int = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        imageCollection.delegate = self
        imageCollection.dataSource = self
        let myNib = UINib(nibName: "InitialAddCollectionViewCell", bundle: nil)
        imageCollection.register(myNib, forCellWithReuseIdentifier: "payCollectionCell")
        // Initialization code
        self.imageCollection.allowsMultipleSelection = false
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (self.parent?.parentRef?.userSetting?.mediator?.refer[myRole]!.count)!
        default:
            return 0
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let keys = self.parent?.parentRef?.userSetting?.currentRoles[self.myRole]
                else {
                    break
            }
            
            if let cell = self.imageCollection.dequeueReusableCell(withReuseIdentifier: "payCollectionCell", for: indexPath) as? InitialAddCollectionViewCell {
                cell.itemLabel.text = NSLocalizedString(keys[indexPath.item], comment: "Item Label")
                cell.checkImage.isHidden = true
                cell.itemImage.image = UIImage(named: keys[indexPath.item])
                if (self.titleSet.count <= indexPath.row) {
                    self.titleSet.append(keys[indexPath.item])
                }
                if (indexPath.item == self.selectedItem) {
                    cell.checkImage.isHidden = false
                    cell.isSelected = true
                }
                return cell
            }
            return UICollectionViewCell()
            
        default:
            break
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = self.imageCollection.cellForItem(at: indexPath) as! InitialAddCollectionViewCell
        cell.checkImage.isHidden = false
        switch self.myRole {
        case .Payer:
            self.parent?.fromName = self.titleSet[indexPath.row]
        case .Payment:
            self.parent?.by = self.titleSet[indexPath.row]
        case .Payee:
            self.parent?.toName = self.titleSet[indexPath.row]
        }
        self.selectedItem = indexPath.item
        // Scroll to the position where is selected.
        self.imageCollection.scrollToItem(at: indexPath, at: .left, animated: true)
        if let cell2 = self.parent?.customTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InitialAddSumCell {
            if (self.imageCollection.indexPathsForVisibleItems[0] == IndexPath(row: 0, section: 0) ) {
                cell2.decimalTF.resignFirstResponder()
            }
        }
        self.imageCollection.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = self.imageCollection.cellForItem(at: indexPath) as? InitialAddCollectionViewCell {
            cell.checkImage.isHidden = true
        }
    }
}
