//
//  RestaurantAddItemViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/11/21.
//

import UIKit
import AlamofireImage
import TinyConstraints
import Firebase
import FirebaseStorage
import FirebaseFirestore
import Kingfisher

class RestaurantAddItemViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var itemImageView: UIImageView!
    
    var imagePicker = UIImagePickerController()
    
    let db = Firestore.firestore()
    let activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.descriptionTextView.layer.borderColor = UIColor.gray.cgColor
        self.descriptionTextView.layer.borderWidth = 2.0
        self.descriptionTextView.layer.cornerRadius = 15
        
        imagePicker.delegate = self
        priceTextField.delegate = self
        // Do any additional setup after loading the view.
        view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()

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
        
        itemImageView.image = scaledImage
        
        //dismiss that camera viw
        dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func onSubmit(_ sender: Any) {
        activityIndicator.startAnimating()
      
        guard let image = itemImageView.image, !(image.isEqual(UIImage(named: "image_placeholder"))),
            (itemImageView.image)!.pngData() != UIImage(named: "image_placeholder")?.pngData(),
            let data = image.jpegData(compressionQuality: 1.0),
            let itemName = itemNameTextField.text, itemName != "",
            let description = descriptionTextView.text, description != "",
            let price = priceTextField.text, price != ""
            else{
                presentAlert(title: "Error", message: "Some fields are missing.")
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
                
                let email = (Auth.auth().currentUser?.email!)!
                let dataReference = self.db.collection(K.FStore.restaurant).document(email).collection(K.FStore.items).document()
                let documentUid = dataReference.documentID
                
                let urlString = url.absoluteString
                let price$ = "$\(price)"
                let data = [
                    K.FStore.uid: documentUid,
                    K.FStore.imageUrl: urlString,
                    K.FStore.itemName : itemName,
                    K.FStore.description: description,
                    K.FStore.price : price
                    ] as [String : Any]
                
                dataReference.setData(data) { (err) in
                    if let err = err {
                        self.presentAlert(title: "Error", message: err.localizedDescription)
                        return
                    }
//                    UserDefaults.standard.set(documentUid, forKey: K.FStore.uid)
                    self.itemImageView.image = #imageLiteral(resourceName: "image_placeholder")
//                     self.presentAlert(title: "Sucessful", message: "Item has been posted")
                    self.activityIndicator.stopAnimating()
                    self.navigationController?.popViewController(animated: true)
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

extension RestaurantAddItemViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // remove non-numerics and compare with original string
        return string == string.filter("0123456789.".contains)
    }
}
