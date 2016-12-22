//
//  File.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import Foundation
import SwiftyJSON
import Mapbox
import GEOSwift

class POI{
    let id: String
    let name: String
    let geometryWKT: String
    var photos = [Photo]()
    
    var mainPhotoUrl: URL?{
        get{
            guard let mainPhotoPath = photos.first?.path else { return nil }
            
            return URL(string: mainPhotoPath)
        }
    }
    
    var geometry: Geometry?{
        return Geometry.create(geometryWKT)
    }
    
    func show(on map:MGLMapView){
        guard let shape = geometry?.mapboxShape() else { return }
        map.addAnnotation(shape)
    }
    
    init(json:JSON){
        id = json["id"].stringValue
        name = json["name"].stringValue
        geometryWKT = json["geometry"].stringValue
        for photoJson in json["photos"].arrayValue{
            photos.append(Photo(json: photoJson))
        }
    }
}
