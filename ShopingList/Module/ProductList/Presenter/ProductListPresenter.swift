//
//  ProductListPresenter.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation

class ProductListPresenter:ViewToPresenterProtocol{
    
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    var loadingIndicator:LoadingIndicatorProtocol?
    
    func fetchProduct(limit: Int, skip: Int) {
        
        interactor?.fetchProduct(limit:limit, skip:skip)
    }
    
    
    
}

extension ProductListPresenter:InteractorToPresenterProtocol{
    
    
    func sendProducts(products: [Product]) {
        
        view?.showProductList(products:products)
    }
    
    func sendFailureMessage(message: String) {
        
        view?.showErrorMessage(message:message)
    }
}

extension ProductListPresenter:LoadingIndicatorProtocol{
    
    func showLoadingIndicator() {
        
        loadingIndicator?.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator?.hideLoadingIndicator()
    }
    
    
    
}
