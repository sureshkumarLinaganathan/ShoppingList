//
//  DataBaseManager.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import CoreData
import UIKit

final class DataBaseManager:NSObject{
    
    static let sharedInstance = DataBaseManager.init()
    var coreDataManager:CoreDataManager = CoreDataManager.init(model:"Database")
    private override init() {
        super.init();
    }
    
    func createNewObject(forentity entityName:String)->NSManagedObject{
        let coreDataManager:CoreDataManager = DataBaseManager.sharedInstance.coreDataManager
        let tempObj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: coreDataManager.getManagedObjectContext())
        return tempObj
    }
    
    func fetchData<T>(forentity entityName:String,predicate:NSPredicate?)->Array<T>?{
        
        let coreDataManager:CoreDataManager = DataBaseManager.sharedInstance.coreDataManager
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        let tempObj:Array<T>? = coreDataManager.fetchData( withRequest: fetchRequest)
        return tempObj
    }
    
    @inline(__always)
    fileprivate class func perforBatchUpadte(forentity entityName:String,predicate:NSPredicate,updateData:Dictionary<String,AnyObject>)->Void{
        
        let req: NSBatchUpdateRequest = NSBatchUpdateRequest(entityName: entityName)
        let predicate:NSPredicate = predicate
        req.predicate = predicate
        req.propertiesToUpdate = updateData
        req.resultType = NSBatchUpdateRequestResultType.updatedObjectsCountResultType
        do{
            let coreDataManager:CoreDataManager = sharedInstance.coreDataManager
            let _:NSBatchUpdateResult = try coreDataManager.getManagedObjectContext().execute(req) as! NSBatchUpdateResult
            
        }catch let error {
            debugPrint(error.localizedDescription)
        }
    }
    
    func saveOrUpdateEntity<T>(forentity entityName:String ,predicate:NSPredicate)->T?{
        let coreDataManager:CoreDataManager = DataBaseManager.sharedInstance.coreDataManager
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = predicate
        let result:Array<T>? = coreDataManager.fetchData( withRequest: fetchRequest)
        
        if nil == result{
            return nil
        }
        var tempObj:T? = nil
        
        if (0 == result?.count){
            // object is not in database perform insert operation
            tempObj =  NSEntityDescription.insertNewObject(forEntityName: entityName, into: coreDataManager.getManagedObjectContext()) as? T
        }else{
            tempObj = result?.first
        }
        return tempObj
    }
    
    func saveManagedContext(){
        let coreDataManager:CoreDataManager = DataBaseManager.sharedInstance.coreDataManager
        coreDataManager.save()
    }
    
    func rollBackManagedContext(){
        let coreDataManager:CoreDataManager = DataBaseManager.sharedInstance.coreDataManager
        coreDataManager.rollback()
    }
    
    func delete(object:NSManagedObject){
        let coreDataManager:CoreDataManager = DataBaseManager.sharedInstance.coreDataManager
        coreDataManager.deleteObject(Object:object)
    }
}

extension DataBaseManager{
    
    
    func saveProduct(product:Product){
        
        
        var arr:[CDProduct] = []
        var obj:CDProduct
        if let idValue = product.id {
            let predicate = NSPredicate(format:"id  == %@",idValue)
            arr = fetchData(forentity:"CDProduct", predicate:predicate)!
        }
        
        if arr.count > 0{
            obj = arr[0]
        }else{
            obj = createNewObject(forentity:"CDProduct") as! CDProduct
        }
        
        obj.id = product.id
        obj.name =   product.name
        obj.prodDes = product.description
        obj.price = product.price
        obj.image = product.image
        if let isEnabled =  product.isAddedToCart{
            obj.isAddedToCart = isEnabled
        }
        coreDataManager.save()
        
        
        
        
    }
}
