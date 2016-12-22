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
    let location: CLLocation
    var photos = [Photo]()
    
    var mainPhotoUrl: URL?{
        get{
            guard let mainPhotoPath = photos.first?.path else { return nil }
            
            return URL(string: mainPhotoPath)
        }
    }
    
    func show(on map:MGLMapView){
        
        var pointAnnotations = [MGLPointAnnotation]()
        
        let poiAnnotation = POIAnnotation()
        poiAnnotation.coordinate = location.coordinate
        poiAnnotation.title = name
        poiAnnotation.poi = self
        pointAnnotations.append(poiAnnotation)
        
        for photo in photos{
            let photoAnnotation = PhotoAnnotation()
            photoAnnotation.coordinate = photo.location.coordinate
            photoAnnotation.title = name
            photoAnnotation.photo = photo
            pointAnnotations.append(photoAnnotation)
        }
        
        map.addAnnotations(pointAnnotations)
    }
    
    init(json:JSON){
        id = json["id"].stringValue
        name = json["name"].stringValue
        
        //location
        let lat = json["location"]["latitude"].doubleValue
        let long = json["location"]["longitude"].doubleValue
        
        location = CLLocation(latitude: lat, longitude: long)
        
        for photoJson in json["photos"].arrayValue{
            photos.append(Photo(json: photoJson))
        }
    }
}
