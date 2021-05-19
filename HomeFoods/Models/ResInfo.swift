//
//  ResInfo.swift
//  HomeFoods
//
//  Created by Duy Le on 5/3/21.
//
import MapKit
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
    let lat: Double
    let lon: Double
    
    var location: CLLocation{
        let lat = lat as CLLocationDegrees
        let lon = lon as CLLocationDegrees
        let locationCoordinate = CLLocation(latitude: lat, longitude: lon)
        return locationCoordinate
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
           return location.distance(from: self.location)
    }
    
    func distanceStr(to location: CLLocation) -> String {
        let dist = distance(to: location) * 0.00062137
        return String(format: "%.2f MI", dist)
    }
    
    func makeAddrLabel(location: CLLocation) -> String{
        let dist = distanceStr(to: location)
        return "\(dist) • \(generalAddr)"
    }
    
    var generalAddr : String {
        let addr = "\(city), \(state) \(zip)"
        return addr
    }
    
    var address : String {
        let addr = "\(street) \(city), \(state) \(zip)"
        return addr
    }
    var imageURL : URL?{
        return URL(string: imageURLString)
    }
    
    var loc : String {
        let loc = "\(city), \(state) \(zip)"
        return loc
    }
}

extension Array where Element == ResInfo {

    mutating func sort(by location: CLLocation) {
        print("Array is sorting!\n")
         return sort(by: { $0.distance(to: location) < $1.distance(to: location) })
    }

    func sorted(by location: CLLocation) -> [ResInfo] {
        return sorted(by: { $0.distance(to: location) < $1.distance(to: location) })
    }
}

