//
//  Extensions.swift
//  Photo Tour
//
//  Created by Anton Kondrashov on 22/12/2016.
//  Copyright © 2016 Anton Kondrashov. All rights reserved.
//

import Foundation
import UIKit

extension UIButton{
    func addBorder(){
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.blue.cgColor
    }
}

extension UIImageView{
    func makeRound(){
        self.layer.cornerRadius = self.bounds.width / 2
        self.layer.masksToBounds = true
    }
}
