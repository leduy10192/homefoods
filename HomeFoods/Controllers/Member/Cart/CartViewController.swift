//
//  CartViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import UIKit

class CartViewController: UIViewController {

    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resAddrLabel: UILabel!
    @IBOutlet weak var resPhoneLabel: UILabel!
    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var resInfo : ResInfo?
    var orderItems : [orderItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        print("First item quanitity: \(orderItems[0].quantity)\n")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: ("Do you want to clear your cart items ?"), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
