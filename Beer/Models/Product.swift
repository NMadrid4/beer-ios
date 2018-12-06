import Foundation
import  SwiftyJSON

class Product {
    var id: String
    var name: String
    var category: String
    var description: String
    var image: String
    var isOffer: Bool
    var price: Double
    var offer: Int
    
    
    init(id: String, name: String, category: String, description: String, image: String, isOffer: Bool, price: Double, offer: Int) {
        self.id = id
        self.name = name
        self.category = category
        self.description = description
        self.image = image
        self.isOffer = isOffer
        self.offer = offer
        self.price = price
    }
    
    static func from(json: JSON) -> Product {
        return Product.init(id: json["_id"].stringValue, name: json["name"].stringValue, category: json["category"].stringValue, description: json["description"].stringValue, image: json["image"].stringValue, isOffer: json["isOffer"].boolValue, price: json["price"].doubleValue, offer: json["offer"].intValue)
    }
    
    static func from(jsonArray: [JSON]) -> [Product] {
        var resultArrray: [Product] = []
        jsonArray.forEach{resultArrray.append(Product.from(json: $0))}
        return resultArrray
    }
    
}
