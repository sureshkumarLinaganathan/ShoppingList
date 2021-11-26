//
//  ServiceProvider.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

protocol ProductListServiceProviderProtocol {
    
    func fetchProducts(successCallback:@escaping successCallback,failureCallback:@escaping failureCallback)
}



class  ServiceProvider:ProductListServiceProviderProtocol{
    
    
    func fetchProducts(successCallback:@escaping successCallback,failureCallback:@escaping failureCallback){
        
        ApiManager.fetchProducts{ (success,response) in
            successCallback(success,response)
        } failureCallback: { (msg) in
            failureCallback(msg)
        }
        
    }
    
    
    
}


