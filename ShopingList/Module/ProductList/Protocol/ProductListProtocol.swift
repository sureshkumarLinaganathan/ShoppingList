//
//  ProductListProtocol.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import Foundation
import UIKit

protocol LoadingIndicatorProtocol{
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
}

protocol SaveProductToDatabaseProtocol {
    
    func addProductToDatabase(product:Product)
}

protocol FetchProductProtocol {
    
    func fetchProduct(limit:Int,skip:Int)
    
}

protocol TransitionProtocol{
    func pushToCartScreen(navigationConroller:UINavigationController)
}


protocol PresenterToRouterProtocol: class,TransitionProtocol {
    
    static func createModule()-> ProductListViewController
    
}

protocol ViewToPresenterProtocol: class,TransitionProtocol,FetchProductProtocol,SaveProductToDatabaseProtocol{
    
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    var cartRouter:CartListPresenterToRouterProtocol? { get set}
   
    
}

protocol PresenterToViewProtocol: class,LoadingIndicatorProtocol{
    
    func showProductList(products:[Product])
    func showErrorMessage(message:String)
    func sendAllDataReceivedStatus(status:Bool)
}

protocol PresenterToInteractorProtocol: class,FetchProductProtocol,SaveProductToDatabaseProtocol {
    
    var presenter:InteractorToPresenterProtocol? {get set}
    
}

protocol InteractorToPresenterProtocol: class,LoadingIndicatorProtocol {
    
    func sendProducts(products:[Product])
    func sendFailureMessage(message:String)
    func sendAllDataReceivedStatus(status:Bool)
}








