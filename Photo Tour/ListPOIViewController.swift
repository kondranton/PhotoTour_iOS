//
//  POIViewController.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit
import GEOSwift
import SwiftSpinner

var markedPhotos = [Photo]()

class ListPOIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var buildRouteBtn: UIButton!
    @IBOutlet weak var chooseCityBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Actions
    
    @IBAction func buildRoute(_ sender: Any) {
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
    
    //MARK: - Properties
    
    var city: City!
    
    var photos = [[Photo]](){
        didSet{
            guard tableView != nil else {
                return
            }
            tableView.reloadData()
        }
    }
    
    var pois = [POI](){
        didSet{
            //get photos
            photos = pois.flatMap{$0.photos}
            
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(-50, 0, 0, 0)
        tableView.tableFooterView = UIView()
        
        buildRouteBtn.addBorder()
        chooseCityBtn.addBorder()
    }
    
    //MARK: - TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return pois.count == 0 ? 0 : photos[section].count + 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! PhotoCell
            let photo = photos[indexPath.section][indexPath.row - 1]
            
            guard let url = photo.url else { return UITableViewCell() }
            
            cell.photoImageView.sd_setImage(with: url)
            cell.isMarked = markedPhotos.contains(photo)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "poiCell") as! POICell
            cell.poi = pois[indexPath.section]
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard indexPath.row != 0 else { return }
        
        let photo = photos[indexPath.section][indexPath.row - 1]
        
        if let index = markedPhotos.index(of: photo){
            markedPhotos.remove(at: index)
        } else {
            markedPhotos.append(photo)
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 100
        } else {
            return 200
        }
    }
    
    //MARK: - Custom methods
    
    func photo(for indexPath: IndexPath) -> Photo{
        return photos[indexPath.section][indexPath.row - 1]
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
        
        if segue.identifier == "toCityChoice"{
            markedPhotos = [Photo]()
        }
    }
}
