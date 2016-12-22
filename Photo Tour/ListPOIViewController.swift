//
//  POIViewController.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit

class ListPOIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var buildRouteBtn: UIButton!
    
    var pois = [POI]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        buildRouteBtn.layer.borderWidth = 2
        buildRouteBtn.layer.borderColor = UIColor.blue.cgColor
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return pois.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "poiCell") as! POICell
        
        cell.poi = pois[indexPath.row]
        
        return cell
    }
}
