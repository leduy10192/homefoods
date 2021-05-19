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
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let db = Firestore.firestore()
    var items : [Item] = []
    
    var resInfo : ResInfo?
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
        loadItems()
    }
    
    func loadItems(){
        let userEmail = (Auth.auth().currentUser?.email!)!
        let email = (resInfo?.email)!
//        print("resEmail \(email)")
        activityIndicator.startAnimating()
        db.collection(K.FStore.restaurant).document(email).collection(K.FStore.items)
            .addSnapshotListener{ (querySnapshot, error) in
            self.items = []
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
                            let newItem = Item(name: itemName, uid: uid, price: price, description: description, imageURLString: imageUrlString)
                            self.items.append(newItem)
                            print("Data",data)
                            print("ITEMS",self.items)
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

extension OrderViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        cell.itemNameLabel.text = items[indexPath.row].name
        cell.itemDescriptionLabel.text = items[indexPath.row].description
        cell.itemPriceLabel.text = items[indexPath.row].price
        if let imageURL = items[indexPath.row].imageURL{
            cell.itemImageView
                .af.setImage(withURL: imageURL)
        }
        return cell
    }


}
