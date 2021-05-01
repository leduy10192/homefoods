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
    
    let db = Firestore.firestore()
    
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
