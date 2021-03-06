//
//  MapPOIViewController.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit
import Mapbox
import GEOSwift
import SwiftSpinner

class MapPOIViewController: UIViewController, MGLMapViewDelegate {

    
    @IBOutlet weak var mapView: MGLMapView!
    @IBOutlet weak var buildRouteBtn: UIButton!
    
    @IBAction func buildRoute(_ sender: UIButton) {
        
        guard markedPhotos.count > 1 else {
            
            let alert = UIAlertController(title: "Oops", message: "You need to choose 2 or more photos to build the route.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let markedPhotoIds = markedPhotos.flatMap{$0.id}
        
        SwiftSpinner.show("Performing Magic...")
        API.buildRoute(from: markedPhotoIds){ wkts in
            guard let wkts = wkts else { return }
            
            var geometries = [Geometry]()
            for wkt in wkts {
                if let validWKT = Geometry.create(wkt){
                    geometries.append(validWKT)
                }
            }
            SwiftSpinner.hide()
            self.performSegue(withIdentifier: "toBuiltRoute", sender: geometries)
        }
    }
    
    var city: City!
    var pois = [POI]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        buildRouteBtn.addBorder()
        setUpMapView()
        showPois()
    }
    
    func setUpMapView(){
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(city.location.coordinate, zoomLevel: 11, animated: false)
        mapView.delegate = self
    }
    
    func showPois(){
        for poi in pois{
            poi.show(on: mapView)
        }
    }
    
    //MARK: - MGLMapViewDelegate
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 1
    }
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return .red
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return .red
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40)))
        var identifier = ""
        
        if let poiAnnotation = annotation as? POIAnnotation{
            guard let url = poiAnnotation.poi?.mainPhotoUrl else { return nil }
            imageView.sd_setImage(with: url)
            identifier = url.absoluteString
        }
        
        if let photoAnnotation = annotation as? PhotoAnnotation{
            guard let url = photoAnnotation.photo?.url else { return nil}
            imageView.sd_setImage(with: url)
            identifier = url.absoluteString
        }
        
        if let reusedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier){
            return reusedView
        }

        let view = MGLAnnotationView(reuseIdentifier: identifier)
        view.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40))
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addSubview(imageView)
        
        return view
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if
            segue.identifier == "toBuiltRoute",
            let destination = segue.destination as? RouteMapViewController,
            let geometries = sender as? [Geometry]{
            
            destination.city = city
            destination.pois = pois
            destination.geometries = geometries
            
        }
    }
    
}
