//
//  ProductListInteractor.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation

class ProductListInteractor:PresenterToInteractorProtocol{
    
    var presenter: InteractorToPresenterProtocol?
    var loadingIndicator:LoadingIndicatorProtocol?
    
    var serviceProvider:ProductListServiceProviderProtocol?
    
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
            
            self?.presenter?.sendProducts(products:arr!)
            
        }, failureCallback: { [weak self](message) in
            
            self?.presenter?.sendFailureMessage(message:message)
            self?.hideLoadingIndicator(hide:skip<limit)
        })
    }
    
    private func sliceProducts(products:[Product],skip:Int,limit:Int)->[Product]{
        
        let startValue = skip
        let endValue = startValue+limit
        
        if products.count >= endValue{
            
            let arr = products[startValue..<endValue]
            return Array(arr)
        }else if products.count >= startValue {
            
            let arr = products[startValue..<products.count]
            return Array(arr)
        }
        return []
    }
}

extension ProductListInteractor{
    
    private func showLoadingIndicator(show:Bool){
        
        if show{
            self.loadingIndicator?.showLoadingIndicator()
        }
    }
    
    private func hideLoadingIndicator(hide:Bool){
        
        if hide {
            self.loadingIndicator?.hideLoadingIndicator()
        }
    }
    
}
