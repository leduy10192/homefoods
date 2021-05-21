//
//  RestaurantSummaryViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import UIKit
import AlamofireImage
import Firebase

class RestaurantSummaryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    let db = Firestore.firestore()
    var restaurantOrderItems : [RestaurantOrderItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "RestaurantSummaryCell", bundle: nil), forCellReuseIdentifier: "RestaurantSummaryCell")
        // Do any additional setup after loading the view.
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        
        loadRestaurantOrders()
    }
    
    func loadRestaurantOrders(){
        let userEmail = (Auth.auth().currentUser?.email!)!
//        let email = (resInfo?.email)!
//        print("resEmail \(email)")
        activityIndicator.startAnimating()
        db.collection(K.FStore.restaurant).document(userEmail).collection(K.FStore.orders)
            .addSnapshotListener{ (querySnapshot, error) in
            self.restaurantOrderItems = []
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
                            let memEmail = data[K.FStore.memberEmail] as? String,
                            let memName = data[K.FStore.memberName] as? String,
                            let memPhone = data[K.FStore.memberPhoneNum] as? String,
                            let addInfo = data[K.FStore.additionalInfo] as? String
                            {
                            let newRestaurantOrderItem = RestaurantOrderItem(name: itemName, uid: uid, price: price, imageURLString: imageUrlString, quantity: quantity, orderDate: orderDate, pickupDate: pickupDate, addInfo: addInfo, memEmail: memEmail, memName: memName, memPhone: memPhone)
                            self.restaurantOrderItems.append(newRestaurantOrderItem)
                            print("DataSummary",data)
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

extension RestaurantSummaryViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantOrderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSummaryCell", for: indexPath) as! RestaurantSummaryCell
        cell.orderDateLabel.text = restaurantOrderItems[indexPath.row].orderDateString
            if let imageURL = restaurantOrderItems[indexPath.row].imageURL{
                cell.headerImageView
                    .af.setImage(withURL: imageURL)
            cell.itemNameLabel.text = restaurantOrderItems[indexPath.row].name
            let quantity = "\(restaurantOrderItems[indexPath.row].quantity)"
            let price$ =  restaurantOrderItems[indexPath.row].price$
            let quantityPrice = "\(price$)  x\(quantity)"
            cell.quantityPriceLabel.text = quantityPrice
            cell.totalLabel.text = "Total: \(restaurantOrderItems[indexPath.row].totalString)"
            cell.pickupDateLabel.text = restaurantOrderItems[indexPath.row].pickupDateString
            cell.memberNameLabel.text = restaurantOrderItems[indexPath.row].memName
            cell.orderUid.text = "Order #: \(restaurantOrderItems[indexPath.row].uid.prefix(5))"
            cell.phoneLabel.text = restaurantOrderItems[indexPath.row].memPhone
        }
//        orderItems[indexPath.row].quantity = cell.itemQuantity
        return cell
    }


}
