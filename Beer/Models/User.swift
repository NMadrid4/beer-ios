import Foundation
import SwiftyJSON

class User {
    var userID: String
    var name: String
    var lastname: String
    var birthdate: String
    var email: String
    var password: String
    var question: String
    var answer: String
    var urlImage: String
    
    init(userID:String, name: String, lastname:String, birthdate:String, email:String, password:String, question: String, answer: String, urlImage: String) {
        self.userID = userID
        self.name = name
        self.lastname = lastname
        self.birthdate = birthdate
        self.email = email
        self.password = password
        self.question = question
        self.answer = answer
        self.urlImage = urlImage
    }
    
    static func from(json: JSON) -> User {
        return User.init(userID: json["_id"].stringValue, name: json["name"].stringValue, lastname: json["lastname"].stringValue, birthdate: json["birthdate"].stringValue, email: json["email"].stringValue, password: json["password"].stringValue, question: json["question"].stringValue, answer: json["answer"].stringValue, urlImage: json["urlImage"].stringValue)
    }
}
