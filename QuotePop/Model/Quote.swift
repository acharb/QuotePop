//
//  Quote.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/21/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit
import CoreData

class Quote: NSManagedObject {
    class func insertQuote(matching quote: String, by author: String, within category: Category, with context: NSManagedObjectContext) -> Quote? {
        
        //instantiating NSManagedObject creates entity in Data base
        let newQuote = Quote(context: context)
        newQuote.author = author
        newQuote.quote = quote
        newQuote.quoter = category
        
        do {
            try context.save()
            return newQuote
        }catch{
            return nil
        }
    }
    
    func setCloudImage(quote: String) {
        
    }
    
    class func fetchAllQuotes(from category: Category, with context: NSManagedObjectContext) -> [Quote]?{
        let request = NSFetchRequest<Quote>(entityName: "Quote")
        request.predicate = NSPredicate(format: "quoter = %@", category)
        
        do{
            let results = try context.fetch(request)
            return results
        }catch{
            print("fetch failed")
            return nil
        }
    }
    
    class func fetchQuote(by author: String, with context: NSManagedObjectContext) -> [Quote]?{
        
        let request = NSFetchRequest<Quote>(entityName: "Quote")
        request.predicate = NSPredicate(format: "author = %@", author)
        
        do{
            let results = try context.fetch(request)
            return results
        }catch {
            print("fetch failed")
            return nil
        }
    }
    
    class func fetchQuote(by id: NSManagedObjectID, with context: NSManagedObjectContext) -> Quote? {
        
        do {
            if let quote = try context.existingObject(with: id) as? Quote {
                return quote
            }
            return nil
        } catch {
            return nil
        }
    }
    
    class func deleteQuotes(from category: Category, with context: NSManagedObjectContext) -> Bool{
        if let quotes = fetchAllQuotes(from: category, with: context){
            for quote in quotes{
                context.delete(quote)
            }
            do {
                try context.save()
                return true
            }catch{
                return false
            }
        }
        return false
    }
    
    class func deleteQuote(quote: Quote, with context: NSManagedObjectContext) -> Bool {
        let id = quote.objectID
        do{
            if let quote = try context.existingObject(with: id) as? Quote {
                do{
                    context.delete(quote)
                    try context.save()
                    return true
                } catch {
                    return false
                }
            }
        }catch {
            return false
        }
        return false
    }
    
    class func update(quote: Quote, toSay: String, with context: NSManagedObjectContext) -> Quote? {
        quote.quote = toSay
        do {
            try context.save()
            return quote
        }catch{
            return nil
        }
    }
}






