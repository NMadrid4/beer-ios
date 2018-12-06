import UIKit

class ForgotPasswordViewController: UIViewController{

    var allQuestions: [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = false
        
        BeerEndPoint.getSecurityQuestions { (secQuestions, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let questions = secQuestions {
                for questions in questions {
                    self.allQuestions.append(questions.stringValue)
                }
                print(self.allQuestions)
            }
        }
    }

}
