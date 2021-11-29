//
//  CartListInteractor.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 29/11/21.
//

import Foundation

class CartListInteractor:PresenterToInteractorProtocol{
    
    var isAllDataReceived: Bool = false
    
    
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
            self?.isAllDataReceived = (products.count == 0 || products.count<limit) ? true:false
            self?.dataSources.append(contentsOf: products)
            self?.presenter?.productFetched()
            
        }, failureCallback: { [weak self](message) in
            
            self?.message = message
            self?.presenter?.productFetchedFailure()
            self?.hideLoadingIndicator(hide:skip<limit)
            self?.isAllDataReceived = false
        })
    }
    
    func remove(product: Product) {
        
        guard  let index = dataSources.firstIndex(where: { $0.id == product.id }) else {
            
            return
        }
        dataSources.remove(at:index)
        
        addProductToDatabase(product:product)
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





