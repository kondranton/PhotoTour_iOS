//
//  City.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftyJSON

class City{
    let id: String
    let name: String
    let photoPath: String
    let location: CLLocation
    
    var photoUrl: URL?{
        get{
            return URL(string: photoPath)
        }
    }
    
    init(json:JSON){
        id = json["id"].stringValue
        name = json["name"].stringValue
        photoPath = json["photo"].stringValue
        
        //location
        let lat = json["location"]["latitude"].doubleValue
        let long = json["location"]["longitude"].doubleValue
        
        location = CLLocation(latitude: lat, longitude: long)
    }
}
