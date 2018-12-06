import Foundation
import Alamofire
import SwiftyJSON

class BeerEndPoint {
    static func loginUser(withEmail email: String, password:String, completionHandler: @escaping(_ user: User?, _ error: String?)->Void) {
        let url = String(format: "\(BeerAPI.baseURL)\(BeerAPI.loginURL)")
        let params = ["email": email,
                      "password": password]
        Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.queryString).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!).dictionaryValue
                if let message = data["mensaje"]?.stringValue {
                    completionHandler(nil, message)
                }else {
                    completionHandler(User.from(json: JSON(response.data!)), nil)
                }
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
    
    static func createUser(user: User, completionHandler: @escaping(_ newIdUser: String?, _ error: String?) -> Void){
        let url = String(format: "\(BeerAPI.baseURL)\(BeerAPI.userURL)")
        let parameters: [String: Any] = [
            "email" : user.email,
            "birthdate": user.birthdate,
            "id" : 0,
            "lastname" : user.lastname,
            "name": user.name,
            "password" : user.password,
            "question" : user.question,
            "answer" : user.answer,
            "urlImage": user.urlImage]
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!)
                completionHandler(data.stringValue, nil)
                print(data)
            case .failure(let error):
                print(error.localizedDescription)
                completionHandler(nil,"No se pudo registrar")
            }

        }
    }
    
    static func getSecurityQuestions(completionHandler: @escaping(_ questions: [JSON]?, _ error: String?)->Void) {
        Alamofire.request("\(BeerAPI.questionsURL)").responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!)
                let questionsArray = data.arrayValue.map{$0["question"]}
                completionHandler(questionsArray, nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getDrinks(completionHandler: @escaping(Utils.productsAlias)) {
        Alamofire.request("\(BeerAPI.baseURL)\(BeerAPI.drinksURL)").responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!).arrayValue
                completionHandler(Product.from(jsonArray: data),nil)
            case .failure(let error):
                completionHandler(nil,"No se puede obtener las bebidas\(error.localizedDescription)")
            }
        }
    }
    
    static func getDrinks(withFilter filter: String, completionHandler: @escaping(Utils.productsAlias)) {
        Alamofire.request("\(BeerAPI.baseURL)\(BeerAPI.drinksURL)\(BeerAPI.filterDrinksURL)\(filter)").responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!).arrayValue
                completionHandler(Product.from(jsonArray: data),nil)
            case .failure(let error):
                completionHandler(nil,"No se puede obtener las bebidas\(error.localizedDescription)")
            }

        }
    }
    
    static func addToCart(userID: String, items: [ [String: Any] ],completionHandler: @escaping(_ message: String?,_ error: String?)->Void) {
        let parameters: [String: Any] = [
            "userId" : userID,
            "detailPurchase": items
        ]
        Alamofire.request("\(BeerAPI.baseURL)\(BeerAPI.pucharseURL)", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!)
                completionHandler(data.stringValue, nil)
            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
    }
    
    static func getPurcharsesFromUser(withIdUser idUser: String, completionHandler: @escaping(_ items: [Purchase]?, _ error: String?)->Void) {
        let url = String(format: "\(BeerAPI.baseURL)\(BeerAPI.allPucharseURL)\(idUser)")
        Alamofire.request("http://localhost:3000/api/purchase/\(idUser)").responseJSON { (response) in
            switch response.result {
            case .success:
                let data = JSON(response.data!).arrayValue
                var items: [Purchase] = []
                data.forEach({items+=Purchase.from(jsonArray: $0.arrayValue)})
                data.forEach({items.append(Purchase.from(json: $0))})
                completionHandler(items,nil)
                
                
//                var i :[PurchaseDetail] = []
//                data.forEach({i+=PurchaseDetail.from(jsonArray: $0["detailPurchase"].arrayValue)})
//                i.forEach({print($0.product)})

            case .failure(let error):
                completionHandler(nil, error.localizedDescription)
            }
        }
        
    }
}
