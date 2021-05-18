//
//  MemberHomeViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/17/21.
//

import UIKit
import MapKit

class MemberHomeViewController: UIViewController {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    let locationManager = CLLocationManager()
    lazy var geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.locationLabel.layer.borderColor = UIColor.gray.cgColor
        self.locationLabel.layer.borderWidth = 1.0
        self.locationLabel.layer.cornerRadius = 15
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    @IBAction func locationClicked(_ sender: Any) {
        self.performSegue(withIdentifier: K.mHomeToSearch, sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.mHomeToSearch {
            let destinationVC = segue.destination as! LocationSearchViewController
            destinationVC.searchText = locationLabel.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            destinationVC.delegate = self
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
    func updateSearchBar(address: String) {
        locationLabel.text = address
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
