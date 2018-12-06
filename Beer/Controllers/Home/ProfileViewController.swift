import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = UserDefaults.standard.object(forKey: Constants.USER) as? [String: String] {
            usernameLabel.text = user["username"]
            lastnameLabel.text = user["lastname"]
            birthdayLabel.text = user["birthdate"]
            emailLabel.text = user["email"]
            
            let url = URL(string: user["urlImage"]!)
            let data = try? Data(contentsOf: url!)
            userImageView.image = UIImage(data: data!)
            userImageView.layer.cornerRadius = userImageView.bounds.width/2.0
        }
    }
    
    @IBAction func closeSessionAction(_ sender: Any) {
        UserDefaults.standard.set(false, forKey: Constants.USERLOGGED)
        let storyboard = UIStoryboard(name: "Authentication", bundle: nil)
        let signInvc = storyboard.instantiateInitialViewController()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.present(signInvc!, animated: true)
        }
    }
}

//        var path = Bundle.main//path until yo
//        var pathForFile = Bundle.main.path(forResource: "imagen1", ofType: "png")
