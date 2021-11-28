//
//  DatabaseServiceProvider.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import Foundation

class DatabaseServiceProvider:ProductListServiceProviderProtocol{
    
    func fetchProducts(limit:Int,skip:Int,successCallback: @escaping successCallback, failureCallback: @escaping failureCallback) {
        
        
        let products =  DataBaseManager.sharedInstance.fetchCartListProduct(limit:limit, skip:skip)
        successCallback(true,products as AnyObject)
        
    }
    
    
    
}
