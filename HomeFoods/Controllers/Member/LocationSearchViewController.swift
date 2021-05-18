//
//  MemberHomeViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/17/21.
//

import UIKit
import MapKit
protocol LocationSearchCellDelegate{
    func updateSearchBar(address: String)
}
class LocationSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultsTable: UITableView!
    
    // Create a seach completer object
    var searchCompleter = MKLocalSearchCompleter()
    var searchText = "";
    // These are the results that are returned from the searchCompleter & what we are displaying
    // on the searchResultsTable
    var searchResults = [MKLocalSearchCompletion]()
    var delegate: LocationSearchCellDelegate?
//    let locationManager = CLLocationManager()
//    lazy var geocoder = CLGeocoder()
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.requestLocation()
        
        searchBar.text = searchText
        searchCompleter.queryFragment = searchText
        //Set up the delgates & the dataSources of both the searchbar & searchResultsTableView
        searchCompleter.delegate = self
        searchBar?.delegate = self
        searchResultsTable?.delegate = self
        searchResultsTable?.dataSource = self
        // Do any additional setup after loading the view.
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

extension LocationSearchViewController: UISearchBarDelegate, MKLocalSearchCompleterDelegate {
    // This method declares that whenever the text in the searchbar is change to also update
    // the query that the searchCompleter will search based off of
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCompleter.queryFragment = searchText
    }
    // This method declares gets called whenever the searchCompleter has new search results
    // If you wanted to do any filter of the locations that are displayed on the the table view
    // this would be the place to do it.
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        // Setting our searcResults variable to the results that the searchCompleter returned
        searchResults = completer.results
        
        // Reload the tableview with our new searchResults
        searchResultsTable.reloadData()
    }
    
    // This method is called when there was an error with the searchCompleter
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // Error
    }
}

// Setting up extensions for the table view
extension LocationSearchViewController: UITableViewDataSource {
    // This method declares the number of sections that we want in our table.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // This method declares how many rows are the in the table
    // We want this to be the number of current search results that the
    // Completer has generated for us
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    // This method delcares the cells that are table is going to show at a particular index
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the specific searchResult at the particular index
        let searchResult = searchResults[indexPath.row]
        
        //Create  a new UITableViewCell object
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        //Set the content of the cell to our searchResult data
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }
}

extension LocationSearchViewController: UITableViewDelegate {
    // This method declares the behavior of what is to happen when the row is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let result = searchResults[indexPath.row]
        self.delegate?.updateSearchBar(address: result.subtitle)
        
        let searchRequest = MKLocalSearch.Request(completion: result)
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            guard let coordinate = response?.mapItems[0].placemark.coordinate else {
                return
            }
            
            guard let name = response?.mapItems[0].name else {
                return
            }
            
            print(name)
            
            let lat = coordinate.latitude
            let lon = coordinate.longitude
            
            print(lat)
            print(lon)
        }
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}


//extension LocationSearchViewController : CLLocationManagerDelegate {
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
//
//        //Update View
//        if let error = error {
//            print("Unable to Reverse Geocode Location (\(error))")
//            searchBar.text = "Unable to Find Address for Location"
//
//        } else {
//            if let placemarks = placemarks, let placemark = placemarks.first {
//
//                searchBar.text = placemark.compactAddress
//                searchCompleter.queryFragment = placemark.compactAddress!
//            } else {
//                searchBar.text = "No Matching Addresses Found"
//            }
//        }
//    }
//
//}
//
//
