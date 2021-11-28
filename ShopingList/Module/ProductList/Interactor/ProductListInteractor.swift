//
//  ProductListInteractor.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation

class ProductListInteractor:PresenterToInteractorProtocol{
    
    
    
    var presenter: InteractorToPresenterProtocol?
    private var serviceProvider:ProductListServiceProviderProtocol?
    
    init(serviceProvider:ProductListServiceProviderProtocol = ServiceProvider()) {
        
        self.serviceProvider = serviceProvider
    }
    
    func fetchProduct(limit: Int, skip: Int) {
        
        
        showLoadingIndicator(show:skip<limit)
        
        self.serviceProvider?.fetchProducts(successCallback: { [weak self](success,response) in
            self?.hideLoadingIndicator(hide:skip<limit)
            guard let products = response as? [Product] else{
                
                self?.presenter?.sendFailureMessage(message:"Incorrect Data format")
                return
            }
            
            let arr = self?.sliceProducts(products:products, skip:skip, limit:limit)
            
            self?.presenter?.sendAllDataReceivedStatus(status: (arr?.count == 0 || arr!.count<limit) ? true:false)
            self?.presenter?.sendProducts(products:arr!)
            self?.saveProductInDatabase(products:products)
        }, failureCallback: { [weak self](message) in
            
            self?.presenter?.sendFailureMessage(message:message)
            self?.hideLoadingIndicator(hide:skip<limit)
            self?.presenter?.sendAllDataReceivedStatus(status: false)
        })
    }
    
    private func sliceProducts(products:[Product],skip:Int,limit:Int)->[Product]{
        
        let startValue = skip
        let endValue = startValue+limit
        
        if products.count >= startValue {
            
            let arr = products[startValue..<min(products.count,endValue)]
            return Array(arr)
        }
        return []
        
    }
}

extension ProductListInteractor{
    
    private func showLoadingIndicator(show:Bool){
        
        if show{
            self.presenter?.showLoadingIndicator()
        }
    }
    
    private func hideLoadingIndicator(hide:Bool){
        
        if hide {
            self.presenter?.hideLoadingIndicator()
        }
    }
    
}


extension ProductListInteractor{
    
    private func saveProductInDatabase(products:[Product]){
        
        for product in products{
            
            addProductToDatabase(product: product)
        }
    }
    
    func addProductToDatabase(product: Product) {
        
        DataBaseManager.sharedInstance.saveProduct(product:product)
    }
}
