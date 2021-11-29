//
//  ProductListInteractor.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation

class ProductListInteractor:PresenterToInteractorProtocol{
    
    var isAllDataReceived: Bool = false
    func remove(product: Product) {
        
    }
    
    var presenter: InteractorToPresenterProtocol?
    private var serviceProvider:ProductListServiceProviderProtocol
    private var fallbackServiceProvider:ProductListServiceProviderProtocol?
    var dataSources:[Product] = []
    
    var message:String?
    
    init(serviceProvider:ProductListServiceProviderProtocol = ServiceProvider(),fallbackServiceProvider:ProductListServiceProviderProtocol? = nil) {
        
        self.serviceProvider = serviceProvider
        self.fallbackServiceProvider = fallbackServiceProvider
    }
    
    
    func fetchProduct(limit: Int, skip: Int) {
        
        let isInternetAvailable = ConnectionManager.shared.hasConnectivity()
        var serviceLayer:ProductListServiceProviderProtocol = serviceProvider
        
        if !isInternetAvailable , let fallbackService = fallbackServiceProvider{
            
            serviceLayer = fallbackService
        }
        showLoadingIndicator(show:skip<limit)
        
        serviceLayer.fetchProducts(limit:limit, skip:skip,successCallback: { [weak self](success,response) in
            self?.hideLoadingIndicator(hide:skip<limit)
            guard let products = response as? [Product] else{
                
                self?.message = "Incorrect Data format"
                self?.presenter?.productFetchedFailure()
                return
            }
            
            self?.isAllDataReceived = (products.count == 0 || products.count<limit) ? true:false
            
            self?.dataSources.append(contentsOf: products)
            DispatchQueue.main.async {
                self?.presenter?.productFetched()
            }
            self?.saveProductInDatabase(products:products)
        }, failureCallback: { [weak self](message) in
            self?.message = message
            self?.isAllDataReceived = false
            DispatchQueue.main.async{
                self?.presenter?.productFetchedFailure()
            }
            self?.hideLoadingIndicator(hide:skip<limit)
            
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
