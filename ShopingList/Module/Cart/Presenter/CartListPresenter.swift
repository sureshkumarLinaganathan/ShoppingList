//
//  CartListPresenter.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import Foundation

class CartListPresenter:CartListViewToPresenterProtocol{
    var interactor: CartListPresenterToInteractorProtocol?
    
    var router: CartListPresenterToRouterProtocol?
    
    var view: CartListPresenterToViewProtocol?
    
    func fetchCartListProduct() {
        
    }
    
    
}

extension CartListPresenter:CartListInteractorToPresenterProtocol{
    
    func sendProducts(products: [Product]) {
        
    }
    
    func sendFailureMessage(message: String) {
        
    }
    
    func sendAllDataReceivedStatus(status: Bool) {
        
    }
    
    
}
