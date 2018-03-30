//
//  InitialAddCollectionViewCell.swift
//  Expense_Test
//
//  Created by Jue Wang on 2018/3/1.
//  Copyright © 2018年 Jue Wang. All rights reserved.
////////////////////////////////////////////////////////////////////
//  Description: The cell for items in collection view
//  Updates:
//  20180307    first version
////////////////////////////////////////////////////////////////////
import UIKit

class InitialAddCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    func setCellContent(name: String, image: UIImage) {
        self.itemLabel.text = name
        self.itemImage.image = image
    }
}
