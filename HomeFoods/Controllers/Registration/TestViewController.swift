//
//  TestViewController.swift
//  HomeFoods
//
//  Created by Duy Le on 5/7/21.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var uiviewtap: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func uiclicked(_ sender: Any) {
        print("clicked")
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
