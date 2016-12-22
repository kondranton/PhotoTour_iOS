//
//  RouteMapViewController.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 22/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit
import Mapbox
import GEOSwift

class RouteMapViewController: UIViewController, MGLMapViewDelegate {

    @IBOutlet weak var mapView: MGLMapView!
    
    var city: City!
    var pois = [POI]()
    var geometries: [Geometry]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpMapView()
        showPois()
    }
    
    func setUpMapView(){
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.setCenter(city.location.coordinate, zoomLevel: 11, animated: false)
        mapView.delegate = self
        
        for geometry in geometries{
            show(geometry: geometry)
        }
        
    }
    
    func show(geometry: Geometry){
        let shape = geometry as! LineString
        
        var coordinates = [CLLocationCoordinate2D]()
        
        for point in shape.points{
            let nextLocation = CLLocationCoordinate2D(latitude: point.x, longitude: point.y)
            coordinates.append(nextLocation)
        }
        
        let polygonShape = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        
        mapView.addAnnotation(polygonShape)
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
        return .blue
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return .red
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return false
    }
    
    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat {
        // Set the line width for polyline annotations
        return 2.0
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        let imageView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40)))
        var identifier = ""
        
        if let poiAnnotation = annotation as? POIAnnotation{
            guard let url = poiAnnotation.poi?.mainPhotoUrl else { return nil }
            imageView.sd_setImage(with: url)
            identifier = url.absoluteString
        } else {
            if let photoAnnotation = annotation as? PhotoAnnotation{
                guard let url = photoAnnotation.photo?.url else { return nil}
                imageView.sd_setImage(with: url)
                identifier = url.absoluteString
            } else {
                return nil
            }
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

}
