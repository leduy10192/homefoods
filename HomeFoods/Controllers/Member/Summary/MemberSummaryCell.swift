//
//  MemberSummaryCell.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import UIKit

class MemberSummaryCell: UITableViewCell {

    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var quantityPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var addInfoLabel: UILabel!
    @IBOutlet weak var pickupDateLabel: UILabel!
    @IBOutlet weak var resNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
