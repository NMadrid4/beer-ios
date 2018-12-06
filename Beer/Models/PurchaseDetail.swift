//
//  PurchaseDetail.swift
//  Beer
//
//  Created by Melanie on 12/3/18.
//

import Foundation
import SwiftyJSON

class PurchaseDetail {
    var cantidad: String
    var product: Product
    
    init(cantidad: String, product: Product) {
        self.product = product
        self.cantidad = cantidad
    }
    
    static func from(json: JSON) -> PurchaseDetail {
        return PurchaseDetail.init(cantidad: json["cantidad"].stringValue, product: Product.from(json: json["item"]))
    }
    
    static func from(jsonArray: [JSON]) -> [PurchaseDetail] {
        var resultArray: [PurchaseDetail] = []
        jsonArray.forEach({resultArray.append(PurchaseDetail.from(json: $0))})
        return resultArray
    }
}
