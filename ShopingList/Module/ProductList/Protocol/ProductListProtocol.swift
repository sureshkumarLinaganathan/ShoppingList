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


protocol PresenterToRouterProtocol: class {
    
    static func createModule()-> ProductListViewController
    func pushToMovieScreen(navigationConroller:UINavigationController)
    
}

protocol ViewToPresenterProtocol: class{
    
    var view: PresenterToViewProtocol? {get set}
    var interactor: PresenterToInteractorProtocol? {get set}
    var router: PresenterToRouterProtocol? {get set}
    func fetchProduct(limit:Int,skip:Int)
    
}

protocol PresenterToViewProtocol: class,LoadingIndicatorProtocol{
    
    func showProductList(products:[Product])
    func showErrorMessage(message:String)
    func sendAllDataReceivedStatus(status:Bool)
}

protocol PresenterToInteractorProtocol: class {
    
    var presenter:InteractorToPresenterProtocol? {get set}
    func fetchProduct(limit:Int,skip:Int)
    
}

protocol InteractorToPresenterProtocol: class,LoadingIndicatorProtocol {
    
    func sendProducts(products:[Product])
    func sendFailureMessage(message:String)
    func sendAllDataReceivedStatus(status:Bool)
}




