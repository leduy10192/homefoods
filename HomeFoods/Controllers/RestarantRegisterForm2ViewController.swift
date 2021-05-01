//
//  RestarantRegisterForm2ViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 4/30/21.
//

import UIKit

class RestarantRegisterForm2ViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.borderWidth = 2.0
        self.textView.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
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
