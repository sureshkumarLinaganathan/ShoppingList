//
//  DataBaseManager.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//


import CoreData

final class CoreDataManager {
    
    //modelname crosspond to coredata resource name
    fileprivate var modelName:String
    
    //modelname crosspond to coredata resource name
    init(model modelName:String) {
        self.modelName = modelName
    }
    
    //MARK:- core data stack
    fileprivate lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    fileprivate lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let url = urls.last!.appendingPathComponent("Database.sqlite")
        
        var failureReason = NSLocalizedString("persistent_store_coordinator_failure", comment: "Error in creating or loading the application's saved data.")
        
        do {
            let persistentStoreOptions = [NSMigratePersistentStoresAutomaticallyOption: true,NSInferMappingModelAutomaticallyOption: true]
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options:persistentStoreOptions)
        } catch let error  {
            //TODO: Replace abort
            debugPrint(error.localizedDescription)
            abort()
        }
        
        return coordinator
    }()
    
    
    fileprivate lazy var managedObjectContext: NSManagedObjectContext? = {
        
        let persistentStoreCoordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
        
    }()
    
    //MARK:- Get instance of NSManagedObjectContext
    
    func getManagedObjectContext() -> NSManagedObjectContext {
        return self.managedObjectContext!
    }
    
    
    
    
    //MARK:- Save function to save data
    func save()->Void {
        if (self.managedObjectContext?.hasChanges)! {
            self.managedObjectContext?.performAndWait({
                do {
                    try self.managedObjectContext?.save()
                } catch let  error  {
                    debugPrint(error.localizedDescription)
                }
            })
        }
        
    }
    
    func rollback()->Void {
        if (self.managedObjectContext?.hasChanges)! {
            self.managedObjectContext?.performAndWait({
                self.managedObjectContext?.rollback()
            })
        }
    }
    
    //MARK:- Fetch data from the database using the  fetch request
    func fetchData<T>(withRequest request: NSFetchRequest<NSFetchRequestResult>)-> Array<T>? {
        var results: Array<T> = []
        self.managedObjectContext?.performAndWait({
            do {
                let resluts = try self.managedObjectContext?.fetch(request)
                results = (resluts as? Array<T>)!
            } catch let error as NSError {
                debugPrint(error)
            }
        })
        
        return results
    }
    
    //MARK:- delete specific object
    func deleteObject(Object:NSManagedObject) -> Void {
        self.managedObjectContext?.performAndWait({
            self.managedObjectContext?.delete(Object)
            self.save()
        })
    }
    
    
}
