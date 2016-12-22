//
//  MapPOIViewController.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit
import Mapbox

class MapPOIViewController: UIViewController, MGLMapViewDelegate {

    
    @IBOutlet weak var mapView: MGLMapView!
    
    var city: City!
    var pois = [POI]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    func setUpMapView(){
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(city.location.coordinate, zoomLevel: 1, animated: false)
        mapView.delegate = self
    }
    
    func showPois(){
        
    }
    
    //MARK: - MGLMapViewDelegate
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 0.5
    }
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .black
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return .red
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
