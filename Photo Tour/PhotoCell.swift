//
//  PhotoCell.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 22/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var checkMarkView: UIImageView!
    
    var isMarked: Bool{
        get{
            return !checkMarkView.isHidden
        }
        set{
            checkMarkView.isHidden = !newValue
        }
    }
}
