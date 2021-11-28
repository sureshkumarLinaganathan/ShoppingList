//
//  CartProtocol.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import Foundation

protocol CartListPresenterToRouterProtocol:class{
    
    static func createModule()->CartListViewController
    
}

protocol CartListViewToPresenterProtocol:class{
    
    var interactor:CartListPresenterToInteractorProtocol? {get set}
    var router:CartListPresenterToRouterProtocol? {get set}
    var view:CartListPresenterToViewProtocol? {get set}
    func fetchCartListProduct()
}

protocol CartListPresenterToViewProtocol:class{
    
    func showProductList(products:[Product])
    func showErrorMessage(message:String)
    func sendAllDataReceivedStatus(status:Bool)
    
    
}

protocol CartListPresenterToInteractorProtocol:class{
    var presenter:CartListInteractorToPresenterProtocol? {get set}
    func fetchCartListProduct()
    
}

protocol CartListInteractorToPresenterProtocol:class{
    
    func sendProducts(products:[Product])
    func sendFailureMessage(message:String)
    func sendAllDataReceivedStatus(status:Bool)
}
