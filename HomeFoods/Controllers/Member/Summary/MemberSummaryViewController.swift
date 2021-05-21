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
    var orderItems : [orderItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
