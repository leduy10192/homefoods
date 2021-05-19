//
//  MemberResDetailViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/18/21.
//

import UIKit
import AlamofireImage

class MemberResDetailViewController: UIViewController {
    
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var kitchenNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var resInfo : ResInfo?
    var address : String = ""
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
