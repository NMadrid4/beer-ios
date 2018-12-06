//
//  PurchaseDetailViewController.swift
//  Beer
//
//  Created by Melanie on 12/3/18.
//

import UIKit
import SDWebImage

class PurchaseDetailViewController: UIViewController {

    @IBOutlet weak var pucharsesCollectionView: UICollectionView!
    
    var productsPucharse: [Product] = []
    var details: [PurchaseDetail]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let details = details {
            details.forEach({productsPucharse.append($0.product)})
            self.pucharsesCollectionView.reloadData()
        }
        self.pucharsesCollectionView.register(UINib(nibName: "CartProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cartProductCell")
    }
}

extension PurchaseDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productsPucharse.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cartProductCell", for: indexPath) as! CartProductsCollectionViewCell
        cell.productNameLabel.text = productsPucharse[indexPath.row].name
        cell.productImageView.sd_setImage(with: URL(string: productsPucharse[indexPath.row].image), placeholderImage: UIImage(named: "imagen"), options: [.continueInBackground, .progressiveDownload], completed: nil)
        cell.cantLabel.text = "Cantidad : \(details![indexPath.row].cantidad)"
        cell.discountLabel.text = "Descuento: \(productsPucharse[indexPath.row].offer)"
        cell.priceLabel.text = "Precio: \(productsPucharse[indexPath.row].price)"
        return cell
    }
    
    
}
