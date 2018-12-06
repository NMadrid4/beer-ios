//
//  PurchaseCollectionViewCell.swift
//  Beer
//
//  Created by Melanie on 12/3/18.
//

import UIKit

class PurchaseCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var purchaseDateLabel: UILabel!
    
    override func awakeFromNib() {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.lightGray.cgColor
    }
}
