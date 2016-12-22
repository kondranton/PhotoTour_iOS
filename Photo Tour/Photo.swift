//
//  Photo.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import Foundation
import SwiftyJSON

class Photo{
    var path: String
    var options: String
    
    init(json:JSON){
        path = json["url"].stringValue
        options = json["options"].stringValue
    }
}
