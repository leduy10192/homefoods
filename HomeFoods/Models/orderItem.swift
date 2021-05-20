//
//  orderItem.swift
//  HomeFoods
//
//  Created by Duy Le on 5/20/21.
//

import Foundation

struct orderItem{
    let name: String
    let uid: String
    let price: String
    let description: String
    let imageURLString: String
    var quantity: Int
    let orderDate: Double
    var pickupDate: Double
    var addInfo: String
    
    var price$ : String {
        return "$\(price)"
    }
    
    var imageURL : URL?{
            return URL(string: imageURLString)
    }
    
    var total : Double {
        return Double(price)! * Double(quantity)
    }
    
    var totalString : String {
        return String(format: "$%.2f", total)
    }
    
    func converDoubleToDateStr( date: Double) -> String{
        let d = Date(timeIntervalSince1970: orderDate)
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM dd, yyyy 'at' h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateStr = formatter.string(from: d)
        return dateStr
    }
    
    var orderDateString : String {
        return converDoubleToDateStr(date: orderDate)
    }
    var pickupDateString : String {
        return converDoubleToDateStr(date: pickupDate)
    }
    
}
