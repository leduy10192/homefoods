//
//  OrderConfirmViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import UIKit
import AlamofireImage

class OrderConfirmViewController: UIViewController {

    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var pickupTimeLabel: UILabel!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var sellerAddrLabel: UILabel!
    @IBOutlet weak var sellerImageView: UIImageView!
    
    var resInfo: ResInfo?
    var orderItems : [orderItem] = []
    var uid: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myBackButton:UIButton = UIButton(type: UIButton.ButtonType.custom) as UIButton
        myBackButton.addTarget(self, action: #selector(popToRoot), for: UIControl.Event.touchUpInside)
        myBackButton.setTitle("Home", for: UIControl.State.normal)
        myBackButton.setTitleColor(UIColor.blue, for: UIControl.State.normal)
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
         self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        var orderNumberString = ""
        for item in orderItems{
            if item.uid == orderItems.last?.uid{
                orderNumberString += "\(item.uid.suffix(5)) "
                break
            }
                orderNumberString += "\(item.uid.suffix(5)), "
        }
        orderNumberLabel.text = orderNumberString
        pickupTimeLabel.text = orderItems[0].pickupDateString
        if let resInfo = resInfo{
            sellerNameLabel.text = resInfo.name
            sellerAddrLabel.text = resInfo.address
            if let imageURL = resInfo.imageURL{
                sellerImageView.af.setImage(withURL: imageURL )
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func popToRoot() {
//            performSegue(withIdentifier: K.OrderConfirmToHome, sender: self)
        navigationController?.popToViewController(ofClass: MemberHomeViewController.self)
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

extension UINavigationController {
  func popToViewController(ofClass: AnyClass, animated: Bool = true) {
    if let vc = viewControllers.last(where: { $0.isKind(of: ofClass) }) {
      popToViewController(vc, animated: animated)
    }
  }
}
