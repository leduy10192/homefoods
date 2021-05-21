//
//  SummaryViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import UIKit
import AlamofireImage
import Firebase

class MemberSummaryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    let db = Firestore.firestore()
    var memberOrderItems : [MemberOrderItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "MemberSummaryCell", bundle: nil), forCellReuseIdentifier: "MemberSummaryCell")
        // Do any additional setup after loading the view.
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        
        loadMemberOrders()
    }
    
    func loadMemberOrders(){
        let userEmail = (Auth.auth().currentUser?.email!)!
//        let email = (resInfo?.email)!
//        print("resEmail \(email)")
        activityIndicator.startAnimating()
        db.collection(K.FStore.member).document(userEmail).collection(K.FStore.memberOrders)
            .addSnapshotListener{ (querySnapshot, error) in
            self.memberOrderItems = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[K.FStore.uid] as? String,
                            let imageUrlString = data[K.FStore.imageUrl] as? String,
                            let itemName = data[K.FStore.name] as? String,
                            let orderDate = data[K.FStore.orderDate] as? Double,
                            let pickupDate = data[K.FStore.pickupDate] as? Double,
                            let price = data[K.FStore.price] as? String,
                            let quantity = data[K.FStore.quantity] as? Int,
                            let resAddress = data[K.FStore.resAddress] as? String,
                            let resEmail = data[K.FStore.resEmail] as? String,
                            let resName = data[K.FStore.resName] as? String,
                            let resPhone = data[K.FStore.resPhone] as? String,
                            let addInfo = data[K.FStore.additionalInfo] as? String
                            {
                            let newMemberOrderItem = MemberOrderItem(name: itemName, uid: uid, price: price, imageURLString: imageUrlString, quantity: quantity, orderDate: orderDate, pickupDate: pickupDate, addInfo: addInfo, resAddress: resAddress, resEmail: resEmail, resName: resName, resPhone: resPhone)
                            self.memberOrderItems.append(newMemberOrderItem)
                            print("Data",data)
//                            print("ITEMS", self.orderItems)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                self.activityIndicator.stopAnimating()
                            }
                        }


//                        if let messageSender = data[K.FStore.] as? String,
//                            let messageBody = data[K.FStore.bodyField] as? String {
//                            let newMessage = Message(sender: messageSender, body: messageBody)
//                            self.messages.append(newMessage)
//                            DispatchQueue.main.async {
//                                self.tableView.reloadData()
//                            }
//                        }
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

extension MemberSummaryViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberOrderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberSummaryCell", for: indexPath) as! MemberSummaryCell
        cell.orderDateLabel.text = memberOrderItems[indexPath.row].orderDateString
            if let imageURL = memberOrderItems[indexPath.row].imageURL{
                cell.headerImageView
                    .af.setImage(withURL: imageURL)
            cell.itemNameLabel.text = memberOrderItems[indexPath.row].name
            let quantity = "\(memberOrderItems[indexPath.row].quantity)"
            let price$ =  memberOrderItems[indexPath.row].price$
            let quantityPrice = "\(price$)  x\(quantity)"
            cell.quantityPriceLabel.text = quantityPrice
            cell.totalLabel.text = "Total: \(memberOrderItems[indexPath.row].totalString)"
            cell.pickupDateLabel.text = memberOrderItems[indexPath.row].pickupDateString
            cell.resNameLabel.text = memberOrderItems[indexPath.row].resName
            cell.addressLabel.text = memberOrderItems[indexPath.row].resAddress
            cell.phoneLabel.text = memberOrderItems[indexPath.row].resPhone
        }
//        orderItems[indexPath.row].quantity = cell.itemQuantity
        return cell
    }


}
