//
//  CartCell.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var priceValLabel: UILabel!
    @IBOutlet weak var QuanValLabel: UILabel!
    @IBOutlet weak var subTotValLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
