//
//  Category.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/21/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit
import CoreData

class Category: NSManagedObject {
    
    class func insertCategory(withTitle title: String, with context: NSManagedObjectContext) -> Category? {
        
        guard fetchAllCategories(with: context).count != 4 else { return nil }
        //instantiating NSManagedObject creates entity in Data base
        let newCategory = Category(context: context)
        newCategory.title = title

        do{
            try context.save()
            return newCategory
        } catch{
            print("couldn't save")
            return nil
        }
    }
    
    class func fetchAllCategories(with context: NSManagedObjectContext) -> [Category]{
        let request = NSFetchRequest<Category>(entityName: "Category")
        
        do {
            let results = try context.fetch(request)
            return results
        } catch {
            print("fetch all failed")
            return []
        }
    }
    
    class func fetchCategory(of title: String, with context: NSManagedObjectContext) -> Category? {
        let request = NSFetchRequest<Category>(entityName: "Category")
        request.predicate = NSPredicate(format: "title = %@", title)
        
        do {
            let results = try context.fetch(request)
            guard results.count > 0 else { return nil}
            return results[0]
        }catch {
            print("fetch failed")
            return nil
        }

    }
    
    class func updateCategoryTitle(with newTitle: String, for category: Category, with context: NSManagedObjectContext) -> Category? {
        
        category.setValue(newTitle, forKey: "title")
        
        do{
            try context.save()
            return category
        }catch{
            print("update failed")
            return nil
        }
    }
    
    class func delete(category: Category, with context: NSManagedObjectContext) -> Bool {
        
            context.delete(category)
            do{
                try context.save()
                return Quote.deleteQuotes(from: category, with: context)
            }catch{
                return false
            }
    }
}









