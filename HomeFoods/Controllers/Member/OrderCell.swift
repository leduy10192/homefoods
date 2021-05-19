//
//  OrderCell.swift
//  HomeFoods
//
//  Created by Duy Le on 5/19/21.
//

import UIKit
import ValueStepper

class OrderCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var valueStepper: ValueStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemDescriptionLabel.lineBreakMode = .byClipping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
