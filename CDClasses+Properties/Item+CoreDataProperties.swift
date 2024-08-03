//
//  Item+CoreDataProperties.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 03/08/24.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var icon: String?
    @NSManaged public var price: Double
    @NSManaged public var name: String?
    @NSManaged public var id: Int64
    @NSManaged public var category: Category?

}

extension Item : Identifiable {

}
