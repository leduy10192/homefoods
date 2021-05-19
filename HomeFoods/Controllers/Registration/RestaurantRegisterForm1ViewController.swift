//
//  RegisterViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 4/30/21.
//

import UIKit
import Firebase

class RestaurantRegisterForm1ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    @IBOutlet weak var signUpTop: NSLayoutConstraint!
    @IBOutlet weak var signUpButton: UIButton!
    
    //tags
    @IBOutlet weak var vegetarianTag: UIButton!
    @IBOutlet weak var glutenFreeTag: UIButton!
    @IBOutlet weak var kitoTag: UIButton!
    @IBOutlet weak var kosherTag: UIButton!
    @IBOutlet weak var dessertsTag: UIButton!
    @IBOutlet weak var lunchTag: UIButton!
    @IBOutlet weak var dairyTag: UIButton!
    @IBOutlet weak var indianTag: UIButton!
    @IBOutlet weak var saladTag: UIButton!

    //flag
    var isVegSet = false
    var isGlutenSet = false
    var isKitoSet = false
    var isKosherSet = false
    var isDessertSet = false
    var isLunchSet = false
    var isDairySet = false
    var isIndianSet = false
    var isSaladSet = false
    
    
    //db initialization
    let db = Firestore.firestore()
    var tags : [String] = []
    var resInfo : ResInfo? = nil
    
    var userType: String = K.FStore.restaurant
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setLeftPaddingPoints(50)
        passwordTextField.setLeftPaddingPoints(50)
        phoneTextField.setLeftPaddingPoints(50)
        nameTextField.setLeftPaddingPoints(50)
        streetField.setLeftPaddingPoints(10)
        cityField.setLeftPaddingPoints(10)
        stateField.setLeftPaddingPoints(10)
        zipField.setLeftPaddingPoints(10)
        print(userType)
        // Do any additional setup after loading the view.
        
        vegetarianTag.layer.cornerRadius = 10
        vegetarianTag.layer.borderColor = UIColor.black.cgColor
        glutenFreeTag.layer.cornerRadius = 10
        glutenFreeTag.layer.borderColor = UIColor.black.cgColor
        kitoTag.layer.cornerRadius = 10
        kitoTag.layer.borderColor = UIColor.black.cgColor
        kosherTag.layer.cornerRadius = 10
        kosherTag.layer.borderColor = UIColor.black.cgColor
        dessertsTag.layer.cornerRadius = 10
        dessertsTag.layer.borderColor = UIColor.black.cgColor
        lunchTag.layer.cornerRadius = 10
        lunchTag.layer.borderColor = UIColor.black.cgColor
        dairyTag.layer.cornerRadius = 10
        dairyTag.layer.borderColor = UIColor.black.cgColor
        indianTag.layer.cornerRadius = 10
        indianTag.layer.borderColor = UIColor.black.cgColor
        saladTag.layer.cornerRadius = 10
    }
    
    @IBAction func segmentPicked(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index == 0 {
            userType = K.FStore.restaurant
            addressLabel.isHidden = false
            streetField.isHidden = false
            cityField.isHidden = false
            stateField.isHidden = false
            zipField.isHidden = false
            let duration: TimeInterval = 0.5
                 UIView.animate(withDuration: duration, animations: {
                    self.signUpTop.constant = 700
                           }, completion: nil)
        }else{
            userType = K.FStore.member
            addressLabel.isHidden = true
            streetField.isHidden = true
            cityField.isHidden = true
            stateField.isHidden = true
            zipField.isHidden = true
            let duration: TimeInterval = 0.5
             UIView.animate(withDuration: duration, animations: {
                self.signUpTop.constant = 350
                       }, completion: nil)
        }
        print(userType)
    }
    
    @IBAction func registerPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, email != "",
            let password = passwordTextField.text, password != ""
            else {
                presentAlert(title: "Invalid Signup", message: "Some Fields are missing")
                return
            }
        if let email = emailTextField.text,
            let password = passwordTextField.text,
            let phoneNum = phoneTextField.text,
            let name = nameTextField.text,
            let street = streetField.text,
            let city = cityField.text,
            let state = stateField.text,
            let zip = zipField.text
            {
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let e = error{
                    self.presentAlert(title: "Invalid Signup", message: "\(e.localizedDescription)")
                }else{
                    self.db.collection(self.userType).document(email).setData([
                        K.FStore.email : email,
                        K.FStore.name : name,
                        K.FStore.phoneNumber : phoneNum,
                        K.FStore.street : street,
                        K.FStore.city : city,
                        K.FStore.state: state,
                        K.FStore.zip: zip
                        
                    
                    ])
                    
                    self.db.collection(self.userType).document(email).collection("orders")
                        .addDocument(data: [
                        K.FStore.email : email,
                    ])
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
    }
    
    func presentAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Res1ToRes2" {
        // remember to down cast it to the destination type (because default func doesn't know the new class type created)
        // cast! forced down cast
            let tagsString = tags.joined(separator: ",")
        if let email = emailTextField.text,
//            let password = passwordTextField.text,
            let phoneNum = phoneTextField.text,
            let name = nameTextField.text,
            let street = streetField.text,
            let city = cityField.text,
            let state = stateField.text,
            let zip = zipField.text
            {
            self.resInfo = ResInfo(name: name, email: email, phoneNumber: phoneNum, street: street, state: state, city: city, zip: zip, imageURLString: "", description: "", kitchenDays: "", tags: tagsString, lat: 0.0, lon: 0.0)
            }
        let destinationVC = segue.destination as! RestarantRegisterForm2ViewController
            destinationVC.resInfo = self.resInfo
            destinationVC.password = self.passwordTextField.text!
        
        }
    }


    
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension RestaurantRegisterForm1ViewController {
    //vegetarian
    @IBAction func vegetarianPressed(_ sender: UIButton) {
        isVegSet = !isVegSet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isVegSet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    @IBAction func glutenPressed(_ sender: UIButton) {
        isGlutenSet = !isGlutenSet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isGlutenSet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    @IBAction func kitoPressed(_ sender: UIButton) {
        isKitoSet = !isKitoSet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isKitoSet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    @IBAction func kosherPressed(_ sender: UIButton) {
        isKosherSet = !isKosherSet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isKosherSet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    @IBAction func dessertPressed(_ sender: UIButton) {
        isDessertSet = !isDessertSet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isDessertSet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    @IBAction func lunchPressed(_ sender: UIButton) {
        isLunchSet = !isLunchSet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isLunchSet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    @IBAction func diaryPressed(_ sender: UIButton) {
        isDairySet = !isDairySet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isDairySet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    @IBAction func indianPressed(_ sender: UIButton) {
        isIndianSet = !isIndianSet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isIndianSet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    @IBAction func saladPressed(_ sender: UIButton) {
        isSaladSet = !isSaladSet
        let button = sender
        let tagName = (button.titleLabel?.text)!
        if(isSaladSet){
            button.layer.borderWidth = 1
            if(!tags.contains(tagName)){
                tags.append(tagName)
            }
        }else{
            button.layer.borderWidth = 0
            if(tags.contains(tagName)){
                tags = tags.filter(){$0 != tagName}
            }
        }
        print(tags)
    }
    
    
}
