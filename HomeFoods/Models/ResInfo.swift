//
//  ResInfo.swift
//  HomeFoods
//
//  Created by Duy Le on 5/3/21.
//

import Foundation

struct ResInfo {
    let name: String
    let email: String
//    let password: String
    let phoneNumber : String
    let street : String
    let state : String
    let city : String
    let zip : String
    let imageURLString : String
    let description : String
    let kitchenDays : String
    let tags : String
    
    var address : String {
        let addr = "\(street) \(city), \(state) \(zip)"
        return addr
    }
    var imageURL : URL?{
        return URL(string: imageURLString)
    }
    
    var location : String {
        let loc = "\(city), \(state) \(zip)"
        return loc
    }
    
}

