import UIKit
import SDWebImage
import Hero

class BeerViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productsOnCartButton: UIButton!
    @IBOutlet weak var categoriesView: UIView!
    @IBOutlet weak var customViewBottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var selectCategoryButton: UIButton!
    
    private var heights: [CGFloat] = []
    private var products: [Product]  = []{
        didSet{
            self.collectionView.reloadData()
            self.products.forEach{_ in self.heights.append(CGFloat(Utils.randomNumber(MIN: 102, MAX: 300)))}
        }
    }
    private let newProductButton = SSBadgeButton()
    var productsOnCar = Int()
    private var categoryFilter = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productsOnCartButton.layer.cornerRadius = productsOnCartButton.bounds.width/2.0
        productsOnCartButton.layer.shadowColor = UIColor.lightGray.cgColor
        productsOnCartButton.layer.shadowOffset = CGSize(width: 3, height: 3)
        productsOnCartButton.layer.shadowOpacity = 1
        productsOnCartButton.layer.shadowRadius = 1.0
        self.view.bringSubview(toFront: categoriesView)
        configBadgeButton()
        
        if let layout = collectionView?.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        getData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Utils.productsOnCar.count == 0 {
            newProductButton.badgeLabel.isHidden = true
        }else {
            newProductButton.badge = "\(Utils.productsOnCar.count)"
        }
        
        productsOnCartButton.addSubview(newProductButton)
    }
    
    private func getData() {
        BeerEndPoint.getDrinks { (receivedProducts, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let newProducts = receivedProducts {
                self.products = newProducts
            }
        }
    }
    
    private func configBadgeButton() {
        newProductButton.frame.size.height = 20
        newProductButton.frame.size.width = 20
        newProductButton.badgeEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -60, right: -45)
    }
    
    private func getDrinksByFilter(filter: String) {
        BeerEndPoint.getDrinks(withFilter: filter, completionHandler: { (productsByFilter, error) in
            if let error = error {
                print(error)
                return
            }
            if let newProducts = productsByFilter {
                DispatchQueue.main.async {
                    self.products.removeAll()
                    self.heights.removeAll()
                    self.products = newProducts
                    self.products.forEach{_ in self.heights.append(CGFloat(Utils.randomNumber(MIN: 102, MAX: 300)))}
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    @IBAction func showCategoriesViewAction(_ sender: UIButton) {
        self.blurView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
            self.customViewBottonConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func selectCategoryAction(_ sender: UIButton) {
        self.blurView.isHidden = true
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseIn, animations: {
            self.customViewBottonConstraint.constant = -(self.categoriesView.frame.size.height+50)
            self.view.layoutIfNeeded()
        }, completion: { finish in
            if finish {
                self.selectCategoryButton.setTitle(sender.titleLabel?.text, for: .normal)
                switch sender.tag {
                case 1 :
                    self.getData()
                case 2 :
                    self.getDrinksByFilter(filter: Constants.BEER)
                default:
                    self.getDrinksByFilter(filter: Constants.LIQUEUR)
                }
                
            }
        })
    }
    
    @IBAction func showProductsOnCartAction(_ sender: Any) {
        
    }
    
}

extension BeerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ProductCollectionViewCell
        cell.imagen.sd_setImage(with: URL(string: products[indexPath.row].image), placeholderImage: UIImage(named: "imagen"), options: [.continueInBackground, .progressiveDownload], completed: nil)
        cell.hero.id = String(indexPath.row)
        cell.nameProductLabel.text = products[indexPath.row].name
        if products[indexPath.row].isOffer == true && products[indexPath.row].offer > 0{
            cell.discountLabel.text = "\(products[indexPath.row].offer)%"
            cell.descuentoView.isHidden = false
        }else {
            cell.descuentoView.isHidden = true
        }
        return cell
    }
    
}

extension BeerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "productDetail") as! ProductDetailViewController
        let cell = collectionView.cellForItem(at: indexPath) as! ProductCollectionViewCell
        let image = cell.imagen.image!
        vc.contentView.hero.id = String(indexPath.row)
        vc.contentView.image = image
        vc.contentView.contentMode = .scaleAspectFill
        vc.contentView.clipsToBounds = true
        vc.contentView.layer.cornerRadius = 10
        vc.prodcut = products[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension BeerViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return heights[indexPath.row]
    }
}
