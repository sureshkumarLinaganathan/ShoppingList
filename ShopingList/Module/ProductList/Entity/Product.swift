//
//  Product.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation

struct Product:Codable{
    
    var id:String?
    var name:String?
    var image:String?
    var description:String?
    var price:String?
    var isAddedToCart:Bool?
}
