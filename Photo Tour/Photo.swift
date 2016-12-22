//
//  Photo.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreLocation

class Photo: Equatable{
    /// Returns a Boolean value indicating whether two values are equal.
    ///
    /// Equality is the inverse of inequality. For any values `a` and `b`,
    /// `a == b` implies that `a != b` is `false`.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    public static func ==(lhs: Photo, rhs: Photo) -> Bool {
         return lhs.path == rhs.path
    }

    var id: String
    var path: String
    var options: String
    var location: CLLocation
    
    var url: URL?{
        get{
            return URL(string: path)
        }
    }
    
    init(json:JSON){
        id = json["id"].stringValue
        path = json["url"].stringValue
        options = json["options"].stringValue
        
        //location
        let lat = json["location"]["latitude"].doubleValue
        let long = json["location"]["longitude"].doubleValue
        
        location = CLLocation(latitude: lat, longitude: long)
    }
}
