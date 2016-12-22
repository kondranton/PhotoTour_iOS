//
//  POITabBarController.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit

class POITabBarController: UITabBarController {

    var city: City!{
        didSet{
            loadPois()
        }
    }
    var pois: [POI]?{
        didSet{
            sharePois()
        }
    }
    
    func loadPois(){
        API.getPOI(forCity: city){ pois in
            self.pois = pois
        }
    }
    
    func sharePois(){
        guard let pois = pois else { return }
        guard let listController = viewControllers?.first as? ListPOIViewController else { return }
        guard let mapController = viewControllers?.last as? MapPOIViewController else { return }
        
        listController.pois = pois
        mapController.pois = pois
    }
}
