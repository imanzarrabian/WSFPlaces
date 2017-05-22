//
//  Review.swift
//  WSFPlaces
//
//  Created by Iman Zarrabian on 22/05/2017.
//  Copyright © 2017 One More Thing Studio. All rights reserved.
//

import Foundation


struct Review {
    let authorName: String
    let authorPhotoUrl: String
    let rating: Double
    let relativeTimeDescription: String
    let text: String

    init(json: [String: Any]) {
        //extracting data from json
        authorName = json["author_name"] as! String
        authorPhotoUrl = json["profile_photo_url"] as! String
        rating = json["rating"] as! Double
        relativeTimeDescription = json["relative_time_description"] as! String
        text = json["text"] as! String
    }
}
