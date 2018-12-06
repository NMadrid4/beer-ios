import Foundation
import UIKit

class Utils {
    
    typealias productsAlias = (_ products: [Product]?, _ error: String?) -> Void
    
    static func randomNumber(MIN: Int, MAX: Int)-> Int{
        return Int(arc4random_uniform(UInt32(MAX-MIN)) + UInt32(MIN));
    }
    
    static func changeBorderOnEdit(sender: HoshTextField) {
        sender.borderActiveColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
        sender.borderInactiveColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
        sender.placeholderColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
    }
    
    static func changeBorderOnError(textField: HoshTextField) {
        textField.borderActiveColor = .red
        textField.borderInactiveColor = .red
        textField.placeholderColor = .red
    }
    
    static func showAlert(withTitle title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let accept = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alert.addAction(accept)
        return alert
    }
    
    struct productsOnCart {
        var id: String
        var productName: String
        var quantity: Int
        var image: UIImage
        var price: Double
        var discount: Double
        var total: Double
    }
    
    static var productsOnCar: [String : productsOnCart] = [:]
    
}
