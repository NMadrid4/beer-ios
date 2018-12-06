import Foundation
import SwiftyJSON

class Purchase {
    var idPurchase: String
    var details: [PurchaseDetail]
    
    
    init(idPurchase: String, products: [PurchaseDetail]) {
        self.idPurchase = idPurchase
        self.details = products
    }
    
    static func from(json: JSON) -> Purchase {
        return Purchase.init(idPurchase: json["_id"].stringValue, products: PurchaseDetail.from(jsonArray: json["detailPurchase"].arrayValue))
    }
    
    static func from(jsonArray: [JSON]) -> [Purchase] {
        var resultArray: [Purchase]  = []
        jsonArray.forEach({resultArray.append(Purchase.from(json: $0))})
        return resultArray
    }
}
