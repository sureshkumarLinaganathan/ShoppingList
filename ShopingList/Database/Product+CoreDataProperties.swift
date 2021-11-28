//
//  Product+CoreDataProperties.swift
//  
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var prodDes: String?
    @NSManaged public var price: String?

}
