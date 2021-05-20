//
//  OrderCell.swift
//  HomeFoods
//
//  Created by Duy Le on 5/19/21.
//

import UIKit
import ValueStepper

protocol OrderCellDelegate {
    func updateQuantity(index: Int, value: Int)
}
class OrderCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var valueStepper: ValueStepper!
    
    var itemQuantity : Int = 0
    var delegate: OrderCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        itemDescriptionLabel.lineBreakMode = .byClipping
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func stepperValueChanged(_ sender: Any) {
//        let stepper = sender as! ValueStepper
//        self.itemQuantity = Int(stepper.value)
        let stepper = sender as! ValueStepper
        guard let indexPath = indexPath else { return }
        self.delegate?.updateQuantity(index: indexPath.row, value: Int(stepper.value))
    }
    
}

extension UITableViewCell{

    var tableView:UITableView?{
        return superview as? UITableView
    }

    var indexPath:IndexPath?{
        return tableView?.indexPath(for: self)
    }

}
