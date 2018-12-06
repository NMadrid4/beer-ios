import UIKit

class CartProductsViewController: UIViewController {

    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cartProductsCollectionView: UICollectionView!
    private let cellIdentifier = "cartProductCell"
    var productsCar: [Utils.productsOnCart] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartProductsCollectionView.register(UINib(nibName: "CartProductsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        let rightGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.backOnSwipe(_:)))
        self.view.addGestureRecognizer(rightGesture)   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Utils.productsOnCar.values.forEach({self.productsCar.append($0)})
        var totalPrice = Double()
        for item in self.productsCar {
            totalPrice+=item.total
        }
        totalPriceLabel.text = "Total = S/.\(totalPrice)"
        self.cartProductsCollectionView.reloadData()
    }
    
    @objc func backOnSwipe(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .right {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func buyProductsOncar() {
        if let user = UserDefaults.standard.object(forKey: Constants.USER) as? [String: String], self.productsCar.count > 0 {
            var parameters: [[String: Any]] = []
            for item in self.productsCar {
                parameters.append(["cantidad" : item.quantity,"item": item.id])
            }
            BeerEndPoint.addToCart(userID: user["userID"]!, items: parameters) { (message, error) in
                if let error = error {
                    let alert = Utils.showAlert(withTitle: Constants.ERROR, message: error)
                    self.present(alert, animated: true)
                    return
                }
                
                if let _ = message {
                    let alert = UIAlertController(title: Constants.NOTICE, message: "Compra realizada", preferredStyle: .alert)
                    let accept = UIAlertAction(title: Constants.DONE, style: .default) { (_) in
                        self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(accept)
                    self.present(alert, animated: true)
                    Utils.productsOnCar.removeAll()
                    self.productsCar.removeAll()
                }
            }
        }else {
            let alert = Utils.showAlert(withTitle: Constants.ERROR, message: "No ha agregado ni un producto aún")
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func buyProducts(_ sender: Any) {
        let alert = UIAlertController(title: Constants.NOTICE, message: "Esta seguro que desea comprar?", preferredStyle: .alert)
        let accept = UIAlertAction(title: Constants.DONE, style: .default) { (_) in
            self.buyProductsOncar()
        }
        let cancel = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alert.addAction(accept)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
}

extension CartProductsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Utils.productsOnCar.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! CartProductsCollectionViewCell
        cell.productImageView.image = self.productsCar[indexPath.row].image
        cell.productNameLabel.text = self.productsCar[indexPath.row].productName
        cell.cantLabel.text = String(self.productsCar[indexPath.row].quantity)
        cell.priceLabel.text = "Precio \(self.productsCar[indexPath.row].price)"
        cell.discountLabel.text = "Descuento \(self.productsCar[indexPath.row].discount)"
        cell.totalLabel.text = "Total \(self.productsCar[indexPath.row].total)"
        return cell
    }
}

extension CartProductsCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  UIScreen.main.bounds.width <= 320 {
            return CGSize(width: 300, height: 160)
        }else {
            return CGSize(width: collectionView.bounds.width, height: 160)
        }
    }
}
