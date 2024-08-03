//
//  CartItem+CoreDataProperties.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 03/08/24.
//
//

import Foundation
import CoreData


extension CartItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CartItem> {
        return NSFetchRequest<CartItem>(entityName: "CartItem")
    }

    @NSManaged public var itemID: Int64
    @NSManaged public var quantity: Int64

}

extension CartItem : Identifiable {

}
