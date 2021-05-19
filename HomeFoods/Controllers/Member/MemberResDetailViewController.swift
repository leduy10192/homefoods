//
//  MemberResDetailViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/18/21.
//

import UIKit
import AlamofireImage
import Cosmos
import MapKit

class MemberResDetailViewController: UIViewController {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var kitchenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var resInfo : ResInfo?
    var address : String = ""
    var myLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imageURL = self.resInfo?.imageURL{
            headerImage.af.setImage(withURL: imageURL
            )
        }
        kitchenNameLabel.text = resInfo?.name
        descriptionLabel.text = resInfo?.description
        addressLabel.text = address
        phoneLabel.text = resInfo?.phoneNumber
        // Do any additional setup after loading the view.
        let tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.5) //change to your liking
        tintView.frame = CGRect(x: 0, y: 0, width: headerImage.frame.width, height: headerImage.frame.height)
        headerImage.addSubview(tintView)
    }
    
    @IBAction func NavigationTrackerPressed(_ sender: Any) {
        if let myLoc = myLocation {
            let userLatitude = myLoc.coordinate.latitude
            let userLongitude = myLoc.coordinate.longitude
            let lat = resInfo?.lat ?? 0.0
            let long = resInfo?.lon ?? 0.0
            let uri = GoogleMapsURIConstructor.prepareURIFor(latitude: lat,
                                                               longitude: long,
                                                               fromLatitude: userLatitude,
                                                               fromLongitude: userLongitude,
                                                               navigation: .driving)!
               UIApplication.shared.open(uri, options: [: ], completionHandler: nil)
        }
    }
        
    @IBAction func callButtonPressed(_ sender: Any) {
        let strPhoneNumber = resInfo!.phoneNumber as String
        makePhoneCall(phoneNumber: strPhoneNumber)
    }
    func makePhoneCall(phoneNumber: String) {

        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {

            let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
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

final public class GoogleMapsURIConstructor {

  public enum NavigationType: String {

    case driving
    case transit
    case walking
  }

  public class func prepareURIFor(latitude lat: Double,
                                  longitude long: Double,
                                  fromLatitude fromLat: Double? = nil,
                                  fromLongitude fromLong: Double? = nil,
                                  navigation navigateBy: NavigationType) -> URL? {
    if let googleMapsRedirect = URL(string: "comgooglemaps://"),
      UIApplication.shared.canOpenURL(googleMapsRedirect) {

      if let fromLat = fromLat,
        let fromLong = fromLong {

        let urlDestination = URL(string: "comgooglemaps-x-callback://?saddr=\(fromLat),\(fromLong)?saddr=&daddr=\(lat),\(long)&directionsmode=\(navigateBy.rawValue)")
        return urlDestination

      } else {

        let urlDestination = URL(string: "comgooglemaps-x-callback://?daddr=\(lat),\(long)&directionsmode=\(navigateBy.rawValue)")
        return urlDestination
      }
    } else {
      if let fromLat = fromLat,
        let fromLong = fromLong {

        let urlDestination = URL(string: "https://www.google.co.in/maps/dir/?saddr=\(fromLat),\(fromLong)&daddr=\(lat),\(long)&directionsmode=\(navigateBy.rawValue)")
        return urlDestination

      } else {

        let urlDestination = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(long)&directionsmode=\(navigateBy.rawValue)")
        return urlDestination
      }
    }
  }
}
