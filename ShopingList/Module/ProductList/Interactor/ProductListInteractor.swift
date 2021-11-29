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
    var dataSources:[Product] = []
    var message:String?
    init(serviceProvider:ProductListServiceProviderProtocol = ServiceProvider()) {
        
        self.serviceProvider = serviceProvider
    }
    
    func fetchProduct(limit: Int, skip: Int) {
        
        
        showLoadingIndicator(show:skip<limit)
        
        self.serviceProvider?.fetchProducts(limit:limit, skip:skip,successCallback: { [weak self](success,response) in
            self?.hideLoadingIndicator(hide:skip<limit)
            guard let products = response as? [Product] else{
                
                self?.presenter?.sendFailureMessage(message:"Incorrect Data format")
                return
            }
            
            self?.presenter?.sendAllDataReceivedStatus(status: (products.count == 0 || products.count<limit) ? true:false)
            self?.dataSources.append(contentsOf: products)
            self?.presenter?.sendProducts(products:products)
            self?.saveProductInDatabase(products:products)
        }, failureCallback: { [weak self](message) in
            self?.message = message
            self?.presenter?.sendFailureMessage(message:message)
            self?.hideLoadingIndicator(hide:skip<limit)
            self?.presenter?.sendAllDataReceivedStatus(status: false)
        })
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
