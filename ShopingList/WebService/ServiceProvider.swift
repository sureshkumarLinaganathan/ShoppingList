//
//  ServiceProvider.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

protocol ProductListServiceProviderProtocol {
    
    func fetchProducts(limit:Int,skip:Int,successCallback:@escaping successCallback,failureCallback:@escaping failureCallback)
}



class  ServiceProvider:ProductListServiceProviderProtocol{
    
    
    func fetchProducts(limit:Int,skip:Int, successCallback:@escaping successCallback,failureCallback:@escaping failureCallback){
        
        ApiManager.fetchProducts(limit:limit, skip:skip) { (succes,response) in
            
            successCallback(succes,response)
            
        } failureCallback: { (message) in
            
            failureCallback(message)
        }
        
    }


}
