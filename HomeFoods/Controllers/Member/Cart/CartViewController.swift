//
//  CartViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import UIKit
import AlamofireImage
import TinyConstraints
import Firebase
import Braintree

class CartViewController: UIViewController {

    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var resAddrLabel: UILabel!
    @IBOutlet weak var resPhoneLabel: UILabel!
    @IBOutlet weak var cartLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var tableView: UITableView!
    let db = Firestore.firestore()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    var braintreeClient: BTAPIClient!
    
    var uid: String = ""
    var resInfo : ResInfo?
    var memberInfo : MemberInfo?
    var orderItems : [orderItem] = []
    var pickupDate : Double = 0.0
    var isDatePicked : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTextView()
//        print("First item quanitity: \(orderItems[0].quantity)\n")
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        //Eliminate extra separators below UITableView
        self.tableView.tableFooterView = UIView()
        
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        
        braintreeClient = BTAPIClient(authorization: "sandbox_7bzw92sx_bkmn4qbwpph22zxt")!
        
        loadMemInfo()
        updateResInfo()
        tableView.reloadData()
        updateTotalPriceUI()
    }
    
    func customizeTextView(){
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.borderWidth = 0.5
        self.textView.layer.cornerRadius = 15
    }
    func updateTotalPriceUI(){
        var subTotal = 0.0
        for item in orderItems {
            if let itemPrice = Double(item.price){
                subTotal += itemPrice * Double(item.quantity)
            }
        }
        totalLabel.text = String (format: "$%.2f", subTotal)
    }
    
    func loadMemInfo() {
        let email = (Auth.auth().currentUser?.email!)!
        db.collection(K.FStore.member).document(email).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }else{
                if let snapshotDocument = querySnapshot{
                    if  let memName = snapshotDocument[K.FStore.name] as? String,
                        let memEmail = snapshotDocument[K.FStore.email] as? String,
                        let memPhone = snapshotDocument[K.FStore.phoneNumber] as? String{
                        self.memberInfo = MemberInfo(memberName: memName, memberEmail: memEmail, memberPhoneNum: memPhone)
                    }
                }
            }
        }
    }
    @IBAction func ProceedPaymentPressed(_ sender: UIButton) {
//        for var item in orderItems {
//            item.addInfo = textView.text
//        }
//        print("datePickerValue \(self.datePicker.date.timeIntervalSince1970)\n")
        if(isDatePicked == false){
            let alert = UIAlertController(title: ("Please select date and time to pick up!"), message: nil, preferredStyle: .alert)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Close", style: .cancel) { _ in }
                 alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        
        activityIndicator.startAnimating()
        let payPalDriver = BTPayPalDriver(apiClient: braintreeClient)

//        payPalDriver.BTViewControllerPresentingDelegate = self
//        payPalDriver.appSwitchDelegate = self // Optional
        
        // Specify the transaction amount here. "2.32" is used in this example.
        let request = BTPayPalCheckoutRequest(amount: "2.32")
        request.currencyCode = "USD" // Optional; see BTPayPalRequest.h for more options

        payPalDriver.tokenizePayPalAccount (with: request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
                print("Got a nonce: \(tokenizedPayPalAccount.nonce)")
                
                
                let email = (Auth.auth().currentUser?.email!)!
                for var item in self.orderItems{
                    //Update seller records, use seller email instead
                    let dataRef = self.db.collection(K.FStore.restaurant).document(self.resInfo!.email).collection(K.FStore.orders).document()
                    let documentUid = dataRef.documentID
                    item.uid = documentUid
                    let data = [
                        K.FStore.uid: documentUid,
                        K.FStore.memberName: self.memberInfo?.memberName ?? "",
                        K.FStore.memberPhoneNum: self.memberInfo?.memberPhoneNum ?? "",
                        K.FStore.memberEmail: self.memberInfo?.memberEmail ?? "",
                        "orderDate": Date().timeIntervalSince1970,
                        "pickupDate": self.pickupDate,
                        K.FStore.name: item.name,
                        K.FStore.price: item.price,
                        K.FStore.quantity: item.quantity,
                        K.FStore.imageUrl: item.imageURLString,
                        K.FStore.additionalInfo: self.textView.text ?? ""
                    ] as [String : Any]
                    
                    dataRef.setData(data) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        }
                    }
                    //put item into orders collection
                    let dataRef2 = self.db.collection(K.FStore.member).document(email).collection(K.FStore.memberOrders).document()
                    let mDocumentUid = dataRef2.documentID
                    let data2 = [
                        K.FStore.uid: mDocumentUid,
                        K.FStore.resName : self.resInfo?.name ?? "",
                        K.FStore.resEmail : self.resInfo?.email ?? "",
                        K.FStore.resAddress: self.resInfo?.address ?? "",
                        K.FStore.resPhone : self.resInfo?.phoneNumber ?? "",
                        "orderDate": Date().timeIntervalSince1970,
                        "pickupDate": self.pickupDate,
                        K.FStore.name: item.name,
                        K.FStore.price: item.price,
                        K.FStore.quantity: item.quantity,
                        K.FStore.imageUrl: item.imageURLString,
                        K.FStore.additionalInfo: self.textView.text ?? ""
                        ] as [String : Any]
                    
                    dataRef2.setData(data2){ (error) in
                        if let err = error {
                            print("Error updating document: \(err)")
                        }
                    }
                }
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: K.CartToOrderConfirm, sender: self)
                }
                
            } else if let error = error {
                print(error)
            } else {
                // Buyer canceled payment approval
            }
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
//        for var item in orderItems{
//            item.pickupDate = sender.date.timeIntervalSince1970
//        }
        self.isDatePicked = true
//        print("pickupDate \(sender.date.timeIntervalSince1970)\n")
        self.pickupDate = sender.date.timeIntervalSince1970
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.CartToOrderConfirm {
            let destinationVC = segue.destination as! OrderConfirmViewController
            destinationVC.orderItems = self.orderItems
            destinationVC.resInfo = self.resInfo
//            destinationVC.uid = self.uid
        }
    }

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

extension CartViewController: BTViewControllerPresentingDelegate {
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
}
 
//extension CartViewController: BTAppSwitchDelegate{
//    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
//
//    }
//
//    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
//
//    }
//
//    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
//
//    }
//}
