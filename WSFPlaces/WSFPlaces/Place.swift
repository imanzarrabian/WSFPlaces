//
//  Place.swift
//  WSFPlaces
//
//  Created by Iman Zarrabian on 25/04/2017.
//  Copyright © 2017 One More Thing Studio. All rights reserved.
//

import Foundation


struct Place {
    let id: String
    let name: String
    let lat: Double
    let lng: Double
    let address: String
    let photo: String
    
    init(json: [String: Any]) {
        //extracting data from json
        id = json["id"] as! String
        name = json["name"] as! String
        address = json["vicinity"] as! String
        
        let geometry = json["geometry"] as! [String: Any]
        let location = geometry["location"] as! [String: Any]
        
        lat = location["lat"] as! Double
        lng = location["lng"] as! Double
        
        photo = json["icon"] as! String
    }
}
