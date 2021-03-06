//
//  API.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct URLS{
    static let localBaseURL = "http://localhost:8889"
    static let baseURL = "http://188.166.36.161:8080"
    
    static let cities = baseURL + "/cities"
    static let pois = baseURL + "/pois"
    static let route = baseURL + "/route"
}

class API{
    
    // GET /cities
    static func getCities(completion: @escaping ([City]?)->Void ){
        
        print(URLS.cities)
        Alamofire.request(URLS.cities, method: .get, parameters: nil).responseJSON { response in
            
            if let jsonData = response.result.value {
                let json = JSON(jsonData)
                
                //extract cities
                var cities = [City]()
                for cityJson in json.arrayValue{
                    cities.append(City(json: cityJson))
                    print(cityJson)
                }
                
                completion(cities)
            } else {
                completion(nil)
            }
        }
    }
    
    // GET /poi?city_id="123"
    
    static func getPOI(forCity city: City, completion: @escaping ([POI]?)->Void){
        
        let id = city.id
        
        Alamofire.request(URLS.pois, method: .get, parameters: ["city_id": id]).responseJSON { response in
            if let jsonData = response.result.value {
                let json = JSON(jsonData)
                
                //extract POIs
                var pois = [POI]()
                for poiJson in json.arrayValue{
                    print(poiJson)
                    pois.append(POI(json: poiJson))
                }
                
                completion(pois)
            } else {
                completion(nil)
            }
        }
        
    }
    
    // POST /route
    
    static func buildRoute(from poiIds: [String], completion: @escaping ([String]?)->Void){
        
        var ids = [[String:String]]()
        ids = poiIds.flatMap{["pin_id": $0]}
        
        print(ids)
        
        Alamofire.request(URLS.route, method: .post, parameters: ["pins": ids], encoding: JSONEncoding.default).responseJSON { response in
           
            if let jsonData = response.result.value {
                let json = JSON(jsonData)
                
                var wkts = [String]()
                
                for legsJson in json["legs"].arrayValue{
                    wkts.append(legsJson["leg"].stringValue)
                }
                
                completion(wkts)
            } else {
                completion(nil)
            }
        }
    }
    
    
    
    
    
    
    
    
    
}
