//
//  Item.swift
//  HomeFoods
//
//  Created by Duy Le on 5/11/21.
//

import Foundation

struct Item{
    let name: String
    let uid: String
    let price: String
    let quantity: String
    let imageURLString: String

    var price$ : String {
        return "$\(price)"
    }
    
    var imageURL : URL?{
            return URL(string: imageURLString)
    }
}
