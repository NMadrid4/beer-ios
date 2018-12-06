import UIKit
import TransitionButton
import Cloudinary

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var dateTextField: HoshTextField!
    @IBOutlet weak var nameTextField: HoshTextField!
    @IBOutlet weak var lastnameTextField: HoshTextField!
    @IBOutlet weak var emailTextField: HoshTextField!
    @IBOutlet weak var passwordTextField: HoshTextField!
    @IBOutlet weak var signUpButton: TransitionButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var questionTextField: HoshTextField!
    @IBOutlet weak var answerTextField: HoshTextField!
    @IBOutlet weak var profileImageVIew: UIImageView!
    @IBOutlet weak var selectImageButton: UIButton!
    
    private var datePicker: UIDatePicker?
    private var questionPicker: UIPickerView?
    private var urlProfileImage: String?
    var allQuestions: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = signUpButton.frame.height/2
        dateTextField.delegate = self
        addDatePicker()
        let tapCloseKeyboard = UITapGestureRecognizer(target: self, action: #selector(closeKeyBoard(_:)))
        view.addGestureRecognizer(tapCloseKeyboard)
        
        addPicker()
        getQuestions()
        registerKeyboardNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardInfo = userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue
        let keyboardSize = keyboardInfo.cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.isScrollEnabled = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    private func getQuestions() {
        BeerEndPoint.getSecurityQuestions { (secQuestions, error) in
            if let error = error {
                print(error)
                return
            }
            
            if let questions = secQuestions {
                for questions in questions {
                    self.allQuestions.append(questions.stringValue)
                }
            }
        }
    }
    
    private func addPicker() {
        questionPicker = UIPickerView()
        questionPicker?.showsSelectionIndicator = true
        questionTextField.inputView = questionPicker
        questionPicker?.backgroundColor = .white
        questionPicker!.dataSource = self
        questionPicker!.delegate = self
        questionTextField.delegate = self
        
        answerTextField.borderActiveColor = .gray
        answerTextField.borderInactiveColor = .gray
        answerTextField.placeholderColor = .gray
        answerTextField.isEnabled = false
    }
    
    private func addDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action:#selector(self.changeDatePicker(datepicker:)), for: .valueChanged)
        dateTextField.inputView = datePicker
        datePicker?.backgroundColor = .white
        
    }
    
    @objc func closeKeyBoard(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5) {
            self.view.endEditing(true)
        }
    }
    
    //validaciones
    private func validateTextFields() -> Bool {
        var isValid = true
        
        if emailTextField.text!.isEmpty{
            self.emailTextField.borderInactiveColor = .red
            self.emailTextField.borderActiveColor = .red
            self.emailTextField.placeholderColor = .red
            isValid = false
        }
        if dateTextField.text!.isEmpty{
            self.dateTextField.borderInactiveColor = .red
            self.dateTextField.borderActiveColor = .red
            self.dateTextField.placeholderColor = .red
            isValid = false
        }
        if lastnameTextField.text!.isEmpty {
            self.lastnameTextField.borderInactiveColor = .red
            self.lastnameTextField.borderActiveColor = .red
            self.lastnameTextField.placeholderColor = .red
            isValid = false
        }
        if nameTextField.text!.isEmpty {
            self.nameTextField.borderInactiveColor = .red
            self.nameTextField.borderActiveColor = .red
            self.nameTextField.placeholderColor = .red
            isValid = false
        }
        if passwordTextField.text!.isEmpty {
            self.passwordTextField.borderInactiveColor = .red
            self.passwordTextField.borderActiveColor = .red
            self.passwordTextField.placeholderColor = .red
            isValid = false
        }
        if questionTextField.text!.isEmpty {
            self.questionTextField.borderInactiveColor = .red
            self.questionTextField.borderActiveColor = .red
            self.questionTextField.placeholderColor = .red
            isValid = false
        }
        if answerTextField.text!.isEmpty {
            self.answerTextField.borderInactiveColor = .red
            self.answerTextField.borderActiveColor = .red
            self.answerTextField.placeholderColor = .red
            isValid = false
        }
        return isValid
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //
    @objc func changeDatePicker(datepicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.DATEFORMAT
        dateTextField.text = dateFormatter.string(from: datepicker.date)
        dateTextField.borderInactiveColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
        dateTextField.borderActiveColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
        dateTextField.placeholderColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
    }
    
    //registrar usuario
    private func signUp(user: User, button: TransitionButton) {
        BeerEndPoint.createUser(user: user) { (newKey, error) in
            if let error = error {
                self.present(Utils.showAlert(withTitle: "Error", message: error),animated: true)
                self.signUpButton.cornerRadius = self.signUpButton.frame.height/2
                button.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.0) {
                    self.selectImageButton.setTitleColor(.red, for: .normal)
                }
                return
            }
            if let _ = newKey {
                button.stopAnimation()
                DispatchQueue.main.asyncAfter(deadline: .now()+1.0, execute: {
                    self.emailTextField.text! = ""
                    self.dateTextField.text! = ""
                    self.lastnameTextField.text! = ""
                    self.nameTextField.text! = ""
                    self.passwordTextField.text! = ""
                    self.questionTextField.text! = ""
                    self.answerTextField.text! = ""
                    self.selectImageButton.setTitleColor(self.selectImageButton.tintColor, for: .normal)
                    self.profileImageVIew.image = UIImage()
                    self.signUpButton.cornerRadius = self.signUpButton.frame.height/2
                    self.signUpButton.clipsToBounds = true
                    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
                    let alert = self.showAlertControler(title: Constants.NOTICE, message: Constants.USERREGISTER, isShowingOnError: false, sender: nil)
                    self.present(alert,animated: true)
                })
            }
        }
        
    }
    
    private func showAlertControler(title: String, message: String, isShowingOnError: Bool, sender: TransitionButton?) -> UIAlertController{
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        var accept = UIAlertAction()
        if isShowingOnError {
            accept = UIAlertAction(title: Constants.DONE, style: .default) { (action) in
                self.stopAnimationButton(sender: sender!)
                self.emailTextField.borderInactiveColor = .red
                self.emailTextField.borderActiveColor = .red
                self.emailTextField.placeholderColor = .red
            }
            
        }else {
            accept = UIAlertAction(title: Constants.DONE, style: .default, handler: { (action) in
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        alert.addAction(accept)
        return alert
    }
    
    private func stopAnimationButton(sender: TransitionButton) {
        sender.cornerRadius = sender.frame.height/2
        sender.clipsToBounds = true
        sender.titleLabel!.text = "REGISTRAR"
        sender.setTitle("REGISTRAR", for: .selected)
        sender.setTitle("REGISTRAR", for: .normal)
        sender.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.0, completion: nil)
    }
    
    //subir imagen a cloudinary
    private func uploadImage(profileImage: UIImage) {
        let config = CLDConfiguration(cloudName: Constants.CLOUDNAME, apiKey: Constants.CLOUDAPIKEY, apiSecret: Constants.CLOUDKEYSECRET)
        let cloudinary = CLDCloudinary(configuration: config)
        let data = UIImagePNGRepresentation(profileImage)
        cloudinary.createUploader().upload(data: data!, uploadPreset: Constants.UPLOADPRESET).response { (result, error) in
            if let result = result {
                self.urlProfileImage = result.url!
            }
        }
    }
    
    @IBAction func changeBorderName(_ sender: HoshTextField) {
        Utils.changeBorderOnEdit(sender: sender)
    }
    
    @IBAction func changeBorderLastName(_ sender: HoshTextField) {
        Utils.changeBorderOnEdit(sender: sender)
    }
    
    @IBAction func changeBorderEmail(_ sender: HoshTextField) {
        Utils.changeBorderOnEdit(sender: sender)
    }
    
    @IBAction func changeBorderPassword(_ sender: HoshTextField) {
        Utils.changeBorderOnEdit(sender: sender)
    }
    
    @IBAction func changeBorderQuestion(_ sender: HoshTextField) {
        Utils.changeBorderOnEdit(sender: sender)
    }
    
    @IBAction func signUpAction(_ sender: TransitionButton) {
        sender.startAnimation()
        guard let userUrlImage = urlProfileImage else {
            self.signUpButton.cornerRadius = self.signUpButton.frame.height/2
            sender.stopAnimation(animationStyle: .shake, revertAfterDelay: 0.0) {
                self.selectImageButton.setTitleColor(.red, for: .normal)
            }
            return
        }
        
        if validateTextFields() {
            if isValidEmail(testStr: emailTextField.text!){
                let user = User.init(userID: "",name: nameTextField.text!, lastname: lastnameTextField.text!, birthdate: dateTextField.text!, email: emailTextField.text!, password: passwordTextField.text!, question: questionTextField.text!, answer: answerTextField.text!, urlImage: userUrlImage)
                signUp(user: user, button: sender)
            }    else {
                let alert = showAlertControler(title: Constants.ERROR, message: Constants.WRONGEMAIL, isShowingOnError: true, sender: sender)
                self.present(alert,animated: true)
            }
            
        }else {
            stopAnimationButton(sender: sender)
            
        }
    }
    
    @IBAction func selectImage(_ sender: Any) {
        let imageVC = UIImagePickerController()
        imageVC.delegate = self
        imageVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imageVC, animated: true)
    }
}

extension RegisterUserViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 0
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}

extension RegisterUserViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return allQuestions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return allQuestions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if  allQuestions.count > 0 {
            questionTextField.text = allQuestions[row]
            answerTextField.borderActiveColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
            answerTextField.borderInactiveColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
            answerTextField.placeholderColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
            questionTextField.borderActiveColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
            questionTextField.borderInactiveColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
            questionTextField.placeholderColor = UIColor(red: 70/255, green: 49/255, blue: 104/255, alpha: 1)
            answerTextField.isEnabled = true
        }
    }
}

extension RegisterUserViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            return
        }
        profileImageVIew.image = image
        self.dismiss(animated: true, completion: {
            DispatchQueue.main.async {
                self.uploadImage(profileImage: image)
            }
            self.selectImageButton.setTitleColor(self.selectImageButton.tintColor, for: .normal)
        })
    }
}
