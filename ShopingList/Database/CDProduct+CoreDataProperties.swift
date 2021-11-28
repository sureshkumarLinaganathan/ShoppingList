//
//  CDProduct+CoreDataProperties.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//
//

import Foundation
import CoreData


extension CDProduct {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDProduct> {
        return NSFetchRequest<CDProduct>(entityName: "CDProduct")
    }

    @NSManaged public var id: String?
    @NSManaged public var image: String?
    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var prodDes: String?
    @NSManaged public var isAddedToCart: Bool

}

extension CDProduct : Identifiable {

}
