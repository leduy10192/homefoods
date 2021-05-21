//
//  MemberHomeViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/17/21.
//

import UIKit
import MapKit
import Firebase
import TinyConstraints
import AlamofireImage

class MemberHomeViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var logoutButton = UIBarButtonItem(image: UIImage(named: "logout"), style: .plain, target: self, action: #selector(logout))
    
    lazy var orderBarButton = UIBarButtonItem(image: UIImage(named: "summary"), style: .plain, target: self, action: #selector(viewOrder))
    
    let locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    var myLocation : CLLocation?
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    let db = Firestore.firestore()
    
    var restaurants : [ResInfo] = []
    var resInfo : ResInfo?
    var addressDetail: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "RestaurantCell", bundle: nil), forCellReuseIdentifier: "RestaurantCell")
        tableView.estimatedRowHeight = 90.0
        tableView.rowHeight = UITableView.automaticDimension
        
        self.locationLabel.layer.borderColor = UIColor.gray.cgColor
        self.locationLabel.layer.borderWidth = 1.0
        self.locationLabel.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        loadRestaurants()
    }
    
    @IBAction func locationClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.mHomeToSearch, sender: self)
    }
    
    // MARK: - Navigation
    func loadRestaurants(){
        let email = (Auth.auth().currentUser?.email!)!
        activityIndicator.startAnimating()
        db.collection(K.FStore.restaurant)
//            .order(by: K.FStore.date)
            .addSnapshotListener{ (querySnapshot, error) in
            self.restaurants = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let resEmail = data[K.FStore.email] as? String,
                           let resName = data[K.FStore.name] as? String,
                           let resPhone = data[K.FStore.phoneNumber] as? String,
                           let resStreet = data[K.FStore.street] as? String,
                           let resCity = data[K.FStore.city] as? String,
                           let resState = data[K.FStore.state] as? String,
                           let resZip = data[K.FStore.zip] as? String,
                           let resImageUrl = data[K.FStore.imageUrl] as? String,
                           let resDescription = data[K.FStore.description] as? String,
                           let resKitchenDays = data[K.FStore.kitchenDays] as? String,
                           let resTags = data[K.FStore.tags] as? String,
                           let lat = data[K.FStore.lat] as? Double,
                           let lon = data[K.FStore.lon] as? Double {
                            let restaurant = ResInfo(name: resName, email: resEmail, phoneNumber: resPhone, street: resStreet, state: resState, city: resCity, zip: resZip, imageURLString: resImageUrl, description: resDescription, kitchenDays: resKitchenDays, tags: resTags, lat: lat, lon: lon)
                            self.restaurants.append(restaurant)
                            print("Data",data)
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
//                    print("myLocation \(String(describing: self.myLocation))\n")
                    if let myLoc =
                        self.myLocation {
//                        print("myLocation \(myLoc)\n")
                        
//                        let dist = self.restaurants[0].distance(to: myLoc)
//                        print("myDist \(dist)\n")
                        self.restaurants.sort(by: myLoc)
                    }
                    print("Restaurants",self.restaurants)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.activityIndicator.stopAnimating()
                    }
                }
            }
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.mHomeToSearch {
            let destinationVC = segue.destination as! LocationSearchViewController
            destinationVC.searchText = locationLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            destinationVC.delegate = self
        }else if segue.identifier == "mHometoDetails" {
            let destinationVC = segue.destination as! MemberResDetailViewController
            destinationVC.resInfo = self.resInfo
            destinationVC.address = addressDetail
            destinationVC.myLocation = self.myLocation
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

extension MemberHomeViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // get the last added location
        if let location = locations.first{
            print("location:: \(location)")
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            // Create Location
            let location = CLLocation(latitude: latitude, longitude: longitude)
            self.myLocation = location
            // Geocode Location
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                // Process Response
                self.processResponse(withPlacemarks: placemarks, error: error)
            }

//            let address = CLGeocoder.init()
//                address.reverseGeocodeLocation(CLLocation.init(latitude: latitude, longitude: longitude)) { (places, error) in
//                    if error == nil{
//                        if let place = places{
//                            //here you can get all the info by combining that you can make address
//                            print("address is \(place.first)" ?? "null")
//                        }
//                    }
//                }

//            searchBar.text = "location:: \(location)"

        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")

    }

    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        
        //Update View
        if let error = error {
            print("Unable to Reverse Geocode Location (\(error))")
            locationLabel.text = "Unable to Find Address for Location"

        } else {
            if let placemarks = placemarks, let placemark = placemarks.first {
                    locationLabel.text = placemark.compactAddress
            } else {
                locationLabel.text = "No Matching Addresses Found"
            }
        }
    }

}

extension MemberHomeViewController: LocationSearchCellDelegate{
    
    func updateSearchBar(address: String, locCors: CLLocation) {
        locationLabel.text = "   \(address)"
        self.myLocation = locCors
        self.restaurants.sort(by: locCors)
        self.tableView.reloadData()
        print("update \(String(describing: locationLabel.text))\n")
    }
}

extension CLPlacemark {
    var compactAddress: String? {
        if let name = name {
            var result = "   \(name)"

            if let street = thoroughfare {
                result += ", \(street)"
            }

            if let city = locality {
                result += ", \(city)"
            }

            if let country = country {
                result += ", \(country)"
            }

            return result
        }

        return nil
    }

}

extension MemberHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: K.RestaurantCell, for: indexPath) as! RestaurantCell
            cell.nameLabel.text = restaurants[indexPath.row].name
            let newString = restaurants[indexPath.row].tags.replacingOccurrences(of: ",", with: " • ", options: .literal, range: nil)
            cell.tagLabel.text = newString
            if let imageURL = restaurants[indexPath.row].imageURL{
                cell.headerImageView.af.setImage(withURL: imageURL)
            }
            
            if let loc = self.myLocation {
                let dist = restaurants[indexPath.row].makeAddrLabel(location: loc)
                print("dist \(dist)")
//                self.addressDetail = dist
                cell.addressLabel.text = dist
            }else{
                cell.addressLabel.text = "pending"
            }
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.resInfo = self.restaurants[indexPath.row]
        if let loc = self.myLocation {
            self.addressDetail = restaurants[indexPath.row].makeAddrLabel(location: loc)
        }
        self.performSegue(withIdentifier: "mHometoDetails", sender: self)
//            print("nagivate to restaurant details")
    }
    
}
