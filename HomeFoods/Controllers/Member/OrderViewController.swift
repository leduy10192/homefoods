//
//  OrderViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/19/21.
//

import UIKit
import AlamofireImage
import TinyConstraints
import Firebase

class OrderViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let db = Firestore.firestore()
    var orderItems : [orderItem] = []
    
    var resInfo : ResInfo?
    var totalQuantity : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "OrderCell")
//        tableView.estimatedRowHeight = 90.0
//        tableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
//        print("resInfo \(resInfo)")
        if(totalQuantity == 0){
            checkoutButton.isEnabled = false
            checkoutButton.isHidden = true
        }
        loadItems()
    }
    
    func loadItems(){
        let userEmail = (Auth.auth().currentUser?.email!)!
        let email = (resInfo?.email)!
//        print("resEmail \(email)")
        activityIndicator.startAnimating()
        db.collection(K.FStore.restaurant).document(email).collection(K.FStore.items)
            .addSnapshotListener{ (querySnapshot, error) in
            self.orderItems = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let uid = data[K.FStore.uid] as? String,
                            let imageUrlString = data[K.FStore.imageUrl] as? String,
                            let itemName = data[K.FStore.itemName] as? String,
                            let description = data[K.FStore.description] as? String,
                            let price = data[K.FStore.price] as? String {
                            let newItem = orderItem(name: itemName, uid: uid, price: price, description: description, imageURLString: imageUrlString, quantity: 0, orderDate: 0.0, pickupDate: 0, addInfo: "")
                            self.orderItems.append(newItem)
                            print("Data",data)
                            print("ITEMS", self.orderItems)
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

    @IBAction func checkoutPressed(_ sender: Any) {
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "rDetailsToOrder" {
//            self.tableView.reloadData()
            let destVC = segue.destination as! CartViewController
            destVC.resInfo = self.resInfo
            let filteredItemsbasedOnQuantity = self.orderItems.filter{$0.quantity > 0}
            destVC.orderItems = filteredItemsbasedOnQuantity
        }
    }

}

extension OrderViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.delegate = self
        cell.itemNameLabel.text = orderItems[indexPath.row].name
        cell.itemDescriptionLabel.text = orderItems[indexPath.row].description
        cell.itemPriceLabel.text = orderItems[indexPath.row].price
        if let imageURL = orderItems[indexPath.row].imageURL{
            cell.itemImageView
                .af.setImage(withURL: imageURL)
        }
//        orderItems[indexPath.row].quantity = cell.itemQuantity
        return cell
    }


}

extension OrderViewController: OrderCellDelegate {
    func updateQuantity(index: Int, value: Int) {
        orderItems[index].quantity = value
        totalQuantity += value
        if(totalQuantity != 0){
            checkoutButton.isEnabled = true
            checkoutButton.isHidden = false
        }else{
            checkoutButton.isEnabled = false
            checkoutButton.isHidden = true
        }
    }
}
