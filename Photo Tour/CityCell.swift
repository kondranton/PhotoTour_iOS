//
//  CityCell.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var cityPhoto: UIImageView!
    
    var city: City!{
        didSet{
            cityName.text = city.name
            if let url = city.photoUrl{
                cityPhoto.sd_setImage(with: url)
                cityPhoto.makeRound()
            }
        }
    }
}
