//
//  RestarantRegisterForm2ViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 4/30/21.
//

import UIKit
import AlamofireImage
import TinyConstraints
import Firebase
import FirebaseStorage
import FirebaseFirestore
import Kingfisher
import CoreLocation

class RestarantRegisterForm2ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var multiSelectPopoverLabel: UILabel!
    @IBOutlet weak var selectDaysButton: UIButton!
    @IBOutlet weak var resImageView: UIImageView!
    
    var resInfo : ResInfo?
    var password: String = ""
    var imagePicker = UIImagePickerController()
    let db = Firestore.firestore()
    
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    /// Simple Data Array
    let dataArray = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    var selectedDataArray = [String]()
    
    /// First Row as selected
    var firstRowSelected = true
    var userType: String = K.FStore.restaurant
    
    /// Cell Selection Style
    var cellSelectionStyle: CellSelectionStyle = .tickmark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.layer.borderColor = UIColor.gray.cgColor
        self.textView.layer.borderWidth = 2.0
        self.textView.layer.cornerRadius = 15
        
        super.viewDidLoad()
        imagePicker.delegate = self
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }
    
    @IBAction func selectDaysButtonClicked(_ sender: UIButton) {
        self.showAsMultiSelectPopover(sender: selectDaysButton!)
    }
    
    @IBAction func onCameraButton(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))

        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        // This image is very large, Heroku has a limit of size image can upload -> import Alamofire and resize it
        let size = CGSize(width: 300, height: 300)
        
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        resImageView.image = scaledImage
        
        //dismiss that camera viw
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        activityIndicator.startAnimating()
      
        guard let image = resImageView.image, !(image.isEqual(UIImage(named: "image_placeholder"))),
            (resImageView.image)!.pngData() != UIImage(named: "image_placeholder")?.pngData(),
            let data = image.jpegData(compressionQuality: 1.0),
            let description = textView.text, description != "",
            let kitchenDays = multiSelectPopoverLabel.text, kitchenDays != ""
            else{
                presentAlert(title: "Error", message: "Some fields are missing.")
                return
        }
        
        guard let resName = resInfo?.name,
            let phoneNumber = resInfo?.phoneNumber,
            let street = resInfo?.street,
            let city = resInfo?.city,
            let state = resInfo?.state,
            let zip = resInfo?.zip,
            let email = resInfo?.email,
            let tags = resInfo?.tags
        else{
            print("resInfo is nil")
            return
        }
        var lat = 0.0
        var lon = 0.0
        let address = resInfo?.address
        if let addr = address {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addr) {
                placemarks, error in
                let placemark = placemarks?.first
                lat = (placemark?.location?.coordinate.latitude)! as Double
                lon = (placemark?.location?.coordinate.longitude)! as Double
                print("Lat: \(String(describing: lat)), Lon: \(String(describing: lon))")
            }
        }else{
            print("lat and lon is nil")
            return
        }
        
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child(K.FStore.imagesFolder).child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                self.presentAlert(title: "Error", message: err.localizedDescription)
                return
            }
            imageReference.downloadURL { (url, err) in
                if let err = err {
                    self.presentAlert(title: "Error", message: err.localizedDescription)
                    return
                }
                guard let url = url else {
                    self.presentAlert(title: "Error", message: "Something went wrong")
                    return
                }
                let urlString = url.absoluteString
                Auth.auth().createUser(withEmail: email, password: self.password) { (authResult, error) in
                    if let e = error{
                        self.presentAlert(title: "Invalid Signup", message: "\(e.localizedDescription)")
                    }else{
                        
                        self.db.collection(self.userType).document(email).setData([
                            K.FStore.email : email,
                            K.FStore.name : resName,
                            K.FStore.phoneNumber : phoneNumber,
                            K.FStore.street : street,
                            K.FStore.city : city,
                            K.FStore.state: state,
                            K.FStore.zip: zip,
                            K.FStore.imageUrl: urlString,
                            K.FStore.description: description,
                            K.FStore.kitchenDays: kitchenDays,
                            K.FStore.tags: tags,
                            K.FStore.lat: lat,
                            K.FStore.lon: lon
                        ])
                        
                        self.db.collection(self.userType).document(email).collection("items")
                            .addDocument(data: [
                            K.FStore.email : email,
                        ])
//                        UserDefaults.standard.set(documentUid, forKey: K.FStore.uid)
                        self.resImageView.image = #imageLiteral(resourceName: "image_placeholder")
    //                     self.presentAlert(title: "Sucessful", message: "Item has been posted")
                        self.activityIndicator.stopAnimating()
//                        self.navigationController?.popViewController(animated: true)
                        self.navigationController?.popToRootViewController(animated: true)
                    }
                }
                
            }
        }
    }
    
    func presentAlert(title: String, message: String) {
        activityIndicator.stopAnimating()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
