//
//  BuyerRegisterViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 4/30/21.
//

import UIKit
import Firebase

class MemberRegisterViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    
    let db = Firestore.firestore()
    var userType: String = K.FStore.member
    
    override func viewDidLoad() {
        emailTextField.setLeftPaddingPoints(50)
        passwordTextField.setLeftPaddingPoints(50)
        phoneTextField.setLeftPaddingPoints(50)
        nameTextField.setLeftPaddingPoints(50)
        streetField.setLeftPaddingPoints(10)
        cityField.setLeftPaddingPoints(10)
        stateField.setLeftPaddingPoints(10)
        zipField.setLeftPaddingPoints(10)
        print(userType)
    }
    
    
    @IBAction func registerPressed(_ sender: Any) {
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

