//
//  ProductListProtocol.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import Foundation
import UIKit

protocol PresenterToRouterProtocol: class {
    
    static func createModule()-> ProductListViewController
    func pushToMovieScreen(navigationConroller:UINavigationController)
    
}

protocol ViewToPresenterProtocol: class{
    
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    var loadingIndicator:LoadingIndicatorProtocol? { get set}
    func fetchProduct(limit:Int,skip:Int)
    
}

protocol PresenterToViewProtocol: class{
    
    func showProductList(products:[Product])
    func showErrorMessage(message:String)
}

protocol PresenterToInteractorProtocol: class {
    
    var presenter:InteractorToPresenterProtocol? {get set}
    var loadingIndicator:LoadingIndicatorProtocol? { get set}
    func fetchProduct(limit:Int,skip:Int)
    
}

protocol InteractorToPresenterProtocol: class {
    
    func sendProducts(products:[Product])
    func sendFailureMessage(message:String)
}

protocol LoadingIndicatorProtocol{
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    
}



