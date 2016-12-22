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
        
        guard let listNavigationController = viewControllers?.first as? UINavigationController else { return }
        guard let mapNavigationController = viewControllers?.last as? UINavigationController else { return }
        
        guard let listController = listNavigationController.viewControllers.first as? ListPOIViewController else { return }
        guard let mapController = mapNavigationController.viewControllers.first as? MapPOIViewController else { return }
        
        listController.pois = pois
        listController.city = city
        
        mapController.pois = pois
        mapController.city = city
    }
}
