//
//  POICell.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 20/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit
import SDWebImage

class POICell: UITableViewCell {

    @IBOutlet weak var poiImage: UIImageView!
    @IBOutlet weak var poiName: UILabel!
    
    var poi: POI!{
        didSet{
            poiName.text = poi.name
            if let url = poi.mainPhotoUrl{
                poiImage.sd_setImage(with: url)
            }
        }
    }
}
