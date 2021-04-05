//
//  PersistenceManager.swift
//  UnsplashAPIFetch
//
//  Created by Дмитрий Ф on 25/05/2020.
//  Copyright © 2020 Dmitry Filippov. All rights reserved.
//

import UIKit
import CoreData

class PersistenceManager {

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private(set) var fetchedRC: NSFetchedResultsController<UnsplashItemEntity>?
//    
//    init() {
//        print(#line, #function, self, "INITIALIZED")
//    }
    
    func saveContext() {
        appDelegate.saveContext()
    }
    
    func saveItem(item: UnsplashItem) {
        let entity = UnsplashItemEntity.entity()
        let context = persistentContainer.viewContext
        let newItem = UnsplashItemEntity(entity: entity, insertInto: context)
        
        newItem.alt_description = item.alt_description
        newItem.created_at = item.created_at
        newItem.id = item.id
        newItem.image = item.image?.pngData() ?? Data()                      // image from imageView ????
        newItem.mainDescription = item.description
        newItem.urls = item.urls as NSObject
        newItem.user = item.user as NSObject
        newItem.searchQuery = item.searchQuery
        newItem.savedDate = Date()
        
        print(#line, #function, "SAVED THE ITEM. Date of saving: \(newItem.savedDate)")
        appDelegate.saveContext()
    }
    
    func requestItems(query: String? = nil, useSection: Bool = false) {
        
        let request = UnsplashItemEntity.fetchRequest() as NSFetchRequest<UnsplashItemEntity>
        if let query = query, !query.isEmpty {
            request.predicate = NSPredicate(format: "searchQuery CONTAINS[cd] %@", query)
        }
        
        let sort = NSSortDescriptor(key: #keyPath(UnsplashItemEntity.savedDate), ascending: true)
        request.sortDescriptors = [sort]
        
        let sectionNameKeyPath = useSection ? #keyPath(UnsplashItemEntity.searchQuery) : nil
        
        fetchedRC = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: persistentContainer.viewContext,
            sectionNameKeyPath: nil, //sectionNameKeyPath,
            cacheName: nil
        )
        
        do {
            try fetchedRC?.performFetch()
        } catch {
            let error = error as NSError
            print(#line, #function, "Could not manage fetch request", error, error.userInfo)
        }
    }
    
//    func fetchItems(completion: ([UnsplashItemEntity]) -> Void ) {
//        do {
//            let items = try context.fetch(UnsplashItemEntity.fetchRequest()) as [UnsplashItemEntity]
//            completion(items)
//        } catch {
//            let error = error as NSError
//            print(#line, #function, "Could not fetch items. Error: \(error), \(error.userInfo)")
//        }
//    }
    
//    func fetchItems(with query: String, useSection: Bool, completion: ([UnsplashItemEntity]) -> () ) {
//        requestItems(query: query, useSection: useSection)
//        
//        let items = fetchedRC.fetchedObjects
////        do {
////            let items = fetc
////        } catch {
////            let error = error as NSError
////            print(#line, #function, "Could not fetch items. Error: \(error), \(error.userInfo)")
////        }
//    }
    
    deinit {
        print(#line, #function, "\(self) DEINITIALIZED")
    }
}
