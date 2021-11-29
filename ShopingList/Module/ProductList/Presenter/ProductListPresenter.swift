//
//  ProductListPresenter.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation
import UIKit

class ProductListPresenter:ViewToPresenterProtocol{
    
    
    var view: PresenterToViewProtocol?
    
    var interactor: PresenterToInteractorProtocol?
    
    var router: PresenterToRouterProtocol?
    
    var cartRouter:CartListPresenterToRouterProtocol?
    
    func fetchProduct(limit: Int, skip: Int) {
        
        interactor?.fetchProduct(limit:limit, skip:skip)
    }
    
    func pushToCartScreen(navigationConroller: UINavigationController) {
        
        router?.pushToCartScreen(navigationConroller:navigationConroller)
    }
    
    func addProductToDatabase(product: Product) {
        
        interactor?.addProductToDatabase(product:product)
    }
    
    func  getProductCount() -> Int? {
        
        return interactor?.dataSources.count
    }
    
    func getProduct(for index: Int) -> Product? {
        
        return interactor?.dataSources[index]
        
    }
    
    func getFailureMessage() -> String? {
        
        return interactor?.message
    }
    
    func removeProduct(for index: Int) {
        
        interactor?.dataSources.remove(at:index)
    }
    
}

extension ProductListPresenter:InteractorToPresenterProtocol{
    
    func sendAllDataReceivedStatus(status: Bool) {
        
        view?.sendAllDataReceivedStatus(status:status)
    }
    
    func productFetched() {
        
        view?.showProductList()
    }
    
    func productFetchedFailure() {
        
        view?.showErrorMessage()
    }
}

extension ProductListPresenter:LoadingIndicatorProtocol{
    
    func showLoadingIndicator() {
        
        view?.showLoadingIndicator()
    }
    
    func hideLoadingIndicator() {
        view?.hideLoadingIndicator()
    }
    
    
    
}

