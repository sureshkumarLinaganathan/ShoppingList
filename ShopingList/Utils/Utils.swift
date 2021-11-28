//
//  Utils.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation
import UIKit

extension UIView{
    
    func makeRoundCorner(radius:CGFloat){
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        
    }
    
    func dropShadow(scale: Bool = true,color:UIColor,radius:CGFloat,offset:CGSize) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1.0
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        
        layer.shadowPath  = UIBezierPath(roundedRect: bounds, cornerRadius:0).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        self.clipsToBounds = false
    }
}
