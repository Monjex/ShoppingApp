//
//  Favorite+CoreDataProperties.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 03/08/24.
//
//

import Foundation
import CoreData


extension Favorite {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Favorite> {
        return NSFetchRequest<Favorite>(entityName: "Favorite")
    }

    @NSManaged public var itemID: Int64

}

extension Favorite : Identifiable {

}
