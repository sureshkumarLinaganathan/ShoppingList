//
//  CartListInteractor.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 29/11/21.
//

import Foundation

class CartListInteractor:PresenterToInteractorProtocol{
    
    var presenter: InteractorToPresenterProtocol?
    
    var dataSources: [Product] = []
    
    var message: String?
    
    private var serviceProvider:ProductListServiceProviderProtocol?
    
    init(serviceProvider:ProductListServiceProviderProtocol = DatabaseServiceProvider()) {
        
        self.serviceProvider = serviceProvider
    }
    
    func fetchProduct(limit: Int, skip: Int) {
        
        
        showLoadingIndicator(show:skip<limit)
        
        self.serviceProvider?.fetchProducts(limit:limit, skip:skip,successCallback: { [weak self](success,response) in
            self?.hideLoadingIndicator(hide:skip<limit)
            guard let products = response as? [Product] else{
                
                self?.message = "Incorrect Data format"
                self?.presenter?.productFetchedFailure()
                return
            }
            
            self?.presenter?.sendAllDataReceivedStatus(status: (products.count == 0 || products.count<limit) ? true:false)
            
            self?.dataSources.append(contentsOf: products)
            self?.presenter?.productFetched()
            
        }, failureCallback: { [weak self](message) in
            
            self?.message = message
            self?.presenter?.productFetchedFailure()
            self?.hideLoadingIndicator(hide:skip<limit)
            self?.presenter?.sendAllDataReceivedStatus(status: false)
        })
    }
    
}

extension CartListInteractor{
    
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


extension CartListInteractor{
    
    func addProductToDatabase(product: Product) {
        
        DataBaseManager.sharedInstance.saveProduct(product:product)
    }
}





