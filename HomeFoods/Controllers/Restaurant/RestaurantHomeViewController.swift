//
//  RestaurantHomeViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/9/21.
//

import UIKit
import Firebase
import TinyConstraints
import AlamofireImage



class RestaurantHomeViewController: UIViewController {

    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var kitchenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let db = Firestore.firestore()
    var resInfo : ResInfo? = nil
    var items : [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "AddCell", bundle: nil), forCellReuseIdentifier: "AddCell")
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableView.automaticDimension
        
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: headerImage.frame.width, height: headerImage.frame.height)
        headerImage.addSubview(tintView)
        // Do any additional setup after loading the view.
        loadResInfo()
        loadItems()
    }
    
    func loadResInfo(){
        let email = (Auth.auth().currentUser?.email!)!
        db.collection(K.FStore.restaurant).document(email).addSnapshotListener { (querySnapshot, error) in
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            }else{
                if let snapshotDocument = querySnapshot{
                    if  let resName = snapshotDocument[K.FStore.name] as? String,
                        let resStreet = snapshotDocument[K.FStore.street] as? String,
                        let resCity = snapshotDocument[K.FStore.city] as? String,
                        let resState = snapshotDocument[K.FStore.state] as? String,
                        let resZip = snapshotDocument[K.FStore.zip] as? String,
                        let resPhone = snapshotDocument[K.FStore.phoneNumber] as? String,
                        let resImageUrl = snapshotDocument[K.FStore.imageUrl] as? String,
                        let resDescription = snapshotDocument[K.FStore.description] as? String,
                        let resKitchenDays = snapshotDocument[K.FStore.kitchenDays] as? String,
                        let resTags = snapshotDocument[K.FStore.tags] as? String
                        
                    {
                        self.resInfo = ResInfo(name: resName, email: email, phoneNumber: resPhone, street: resStreet, state: resState
                                               , city: resCity, zip: resZip, imageURLString: resImageUrl, description: resDescription, kitchenDays: resKitchenDays, tags: resTags)
                        DispatchQueue.main.async {
                            self.kitchenNameLabel.text = self.resInfo?.name
                            self.descriptionLabel.text = self.resInfo?.description
                            if let imageURL = self.resInfo?.imageURL{
                                self.headerImage.af.setImage(withURL: imageURL)
                            }
                            self.addressLabel.text = self.resInfo?.address
                            self.phoneLabel.text = self.resInfo?.phoneNumber
                        }
                }
            }
        }
    }
}
    func loadItems(){
        let email = (Auth.auth().currentUser?.email!)!
        activityIndicator.startAnimating()
        db.collection(K.FStore.restaurant).document(email).collection(K.FStore.items)
//            .order(by: K.FStore.date)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "RHomeToRAdd" {
        // remember to down cast it to the destination type (because default func doesn't know the new class type created)
        // cast! forced down cast
//        let destinationVC = segue.destination as! RestaurantAddItemController
//            destinationVC.resInfo = self.resInfo
//
//        }
//    }

}

extension RestaurantHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == items.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCell", for: indexPath) as! AddCell
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! PostCell
            cell.nameLabel.text = items[indexPath.row].name
            cell.priceLabel.text = items[indexPath.row].price
            cell.descriptionLabel.text = items[indexPath.row].description
            if let imageURL = items[indexPath.row].imageURL{
                cell.postImage.af.setImage(withURL: imageURL)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == items.count {
           self.performSegue(withIdentifier: "RHomeToRAdd", sender: self)
        }
    }
    
}

