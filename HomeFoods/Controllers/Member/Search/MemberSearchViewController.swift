//
//  MemberHomeViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/17/21.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch: AnyObject {
    func dropPinZoomIn(placemark:MKPlacemark)
}

class MemberSearchViewController: UIViewController {
//    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchView: UIView!
    
    @IBOutlet weak var mapView: MKMapView!
    
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController!
    
    let locationManager = CLLocationManager()
    
    lazy var geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()        // Do any additional setup after loading the view.
        
        
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
//        searchView = resultSearchController?.searchBar
        resultSearchController.hidesNavigationBarDuringPresentation = false
        resultSearchController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        locationSearchTable.mapView = mapView
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    @objc func getDirections(){
        guard let selectedPin = selectedPin else { return }
        let mapItem = MKMapItem(placemark: selectedPin)
        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        mapItem.openInMaps(launchOptions: launchOptions)
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

extension MemberSearchViewController : CLLocationManagerDelegate {
    
//    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse  {
//            locationManager.requestLocation()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error)")
    }

}

extension MemberSearchViewController: HandleMapSearch {
    
    func dropPinZoomIn(placemark: MKPlacemark){
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
                annotation.subtitle = "\(city) \(state)"
        }
        
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
}

extension MemberSearchViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        guard !(annotation is MKUserLocation) else { return nil }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        }
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        let smallSquare = CGSize(width: 30, height: 30)
        let button = UIButton(frame: CGRect(origin: .zero, size: smallSquare))
        button.setBackgroundImage(UIImage(named: "car"), for: [])
        button.addTarget(self, action: #selector(MemberSearchViewController.getDirections), for: .touchUpInside)
        pinView?.leftCalloutAccessoryView = button
        
        return pinView
    }
}


//extension MemberHomeViewController : CLLocationManagerDelegate {
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        // get the last added location
//        if let location = locations.first{
//            print("location:: \(location)")
//            let latitude = location.coordinate.latitude
//            let longitude = location.coordinate.longitude
//
//            // Create Location
//            let location = CLLocation(latitude: latitude, longitude: longitude)
//
//            // Geocode Location
//            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
//                // Process Response
//                self.processResponse(withPlacemarks: placemarks, error: error)
//            }
//
////            let address = CLGeocoder.init()
////                address.reverseGeocodeLocation(CLLocation.init(latitude: latitude, longitude: longitude)) { (places, error) in
////                    if error == nil{
////                        if let place = places{
////                            //here you can get all the info by combining that you can make address
////                            print("address is \(place.first)" ?? "null")
////                        }
////                    }
////                }
//
////            searchBar.text = "location:: \(location)"
//
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("error:: \(error)")
//
//    }
//
//    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
//         Update View
//
//        if let error = error {
//            print("Unable to Reverse Geocode Location (\(error))")
//            searchBar.text = "Unable to Find Address for Location"
//
//        } else {
//            if let placemarks = placemarks, let placemark = placemarks.first {
//                searchBar.text = placemark.compactAddress
//            } else {
//                searchBar.text = "No Matching Addresses Found"
//            }
//        }
//    }
//
//}
//
//extension CLPlacemark {
//
//    var compactAddress: String? {
//        if let name = name {
//            var result = name
//
//            if let street = thoroughfare {
//                result += ", \(street)"
//            }
//
//            if let city = locality {
//                result += ", \(city)"
//            }
//
//            if let country = country {
//                result += ", \(country)"
//            }
//
//            return result
//        }
//
//        return nil
//    }
//
//}
