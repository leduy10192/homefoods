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
        customizeTextView()
//        print("First item quanitity: \(orderItems[0].quantity)\n")
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        updateResInfo()
        tableView.reloadData()
    }
    
    func customizeTextView(){
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.cornerRadius = 15
    }
    
    @IBAction func ProceedPaymentPressed(_ sender: UIButton) {
        for var item in orderItems {
            item.addInfo = textView.text
        }
    }
    
    func updateResInfo(){
        if let resInfo = resInfo {
            resNameLabel.text = resInfo.name
            resAddrLabel.text = resInfo.address
            resPhoneLabel.text = resInfo.phoneNumber
            cartLabel.text = "Cart (\(orderItems.count))"
        }else{
            print("ResInfo is nil")
        }
    }
    
    @IBAction func clearButtonPressed(_ sender: Any) {
        let alert = UIAlertController(title: ("Do you want to clear your cart items ?"), message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            self.navigationController?.popViewController(animated: true)
        }))

        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func datePickedValueChanged(_ sender: UIDatePicker) {
        for var item in orderItems{
            item.pickupDate = sender.date.timeIntervalSince1970
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

extension CartViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.itemNameLabel.text = orderItems[indexPath.row].name
        let price = orderItems[indexPath.row].price
        let quantity = orderItems[indexPath.row].quantity
        let subTotal = Double(price)! * Double(quantity)
        cell.priceValLabel.text = price
        cell.QuanValLabel.text =  String(quantity)
        cell.subTotValLabel.text = String(subTotal)
        
        return cell
    }
}
