//
//  RestaurantLoginViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/6/21.
//

import UIKit
import Firebase

class RestaurantLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.setLeftPaddingPoints(50)
        passwordTextField.setLeftPaddingPoints(50)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailTextField.text , let password = passwordTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                    let alert = UIAlertController(
                    title: "Invalid Login",
                    message: "User Login failed: \(e.localizedDescription)",
                    preferredStyle: UIAlertController.Style.alert)
                    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                        
                    }
                    alert.addAction(OKAction)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    let result = self.db.collection(K.FStore.restaurant).document(email)
                    result.getDocument { (snapshot, error) in
                        if let doc = snapshot{
                            if doc.exists{
                                print("success")
                                self.performSegue(withIdentifier: K.restaurantLogSeg, sender: self)
                            }else{
                                let alert = UIAlertController(
                                title: "Invalid Login",
                                message: "User Login failed: Please login using Member Portal",
                                preferredStyle: UIAlertController.Style.alert)
                                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                                }
                                alert.addAction(OKAction)
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
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
