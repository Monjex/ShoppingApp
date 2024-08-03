//
//  CoreDataManager.swift
//  tummocShoppingApp
//
//  Created by TGPL-MACMINI-66 on 03/08/24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager() // Singleton instance
    
    private init() {} // Private initializer to ensure singleton
    
    // Function to load data from JSON and save to Core Data
    func loadData(context: NSManagedObjectContext) {
        guard let url = Bundle.main.url(forResource: "shoppingList", withExtension: "json") else {
            print("Failed to locate shoppingList.json in bundle.")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            let categoriesJSON = json?["categories"] as? [[String: Any]] ?? []
            
            // Delete existing categories and items
            deleteExistingData(context: context)
            
            for categoryJSON in categoriesJSON {
                let categoryID = categoryJSON["id"] as? Int64 ?? 0
                
                let category = Category(context: context)
                category.id = categoryID
                category.name = categoryJSON["name"] as? String
                
                if let itemsJSON = categoryJSON["items"] as? [[String: Any]] {
                    for itemJSON in itemsJSON {
                        let item = Item(context: context)
                        item.id = itemJSON["id"] as? Int64 ?? 0
                        item.name = itemJSON["name"] as? String
                        item.icon = itemJSON["icon"] as? String
                        item.price = itemJSON["price"] as? Double ?? 0.0
                        item.category = category
                    }
                }
            }
            
            try context.save()
            print("Data saved to Core Data successfully.")
        } catch {
            print("Failed to load or save data: \(error)")
        }
    }
    
    func deleteExistingData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            print("Existing data deleted.")
        } catch {
            print("Failed to delete existing data: \(error)")
        }
    }
    
    // Function to fetch categories from Core Data
    func fetchCategories(context: NSManagedObjectContext) -> [Category] {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)] // Sort by ID or any other attribute if needed
        
        do {
            let categories = try context.fetch(fetchRequest)
            return categories
        } catch {
            print("Failed to fetch categories: \(error)")
            return []
        }
    }
    

}
