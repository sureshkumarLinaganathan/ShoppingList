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
    
    func getProductCount()->Int?
    func getProduct(for index:Int)->Product?
    func getFailureMessage()->String?
    func remove(product:Product)
    func getAllDataReceivedStatus()->Bool?
}

protocol PresenterToViewProtocol: class,LoadingIndicatorProtocol{
    
    func showProductList()
    func showErrorMessage()
    
}

protocol PresenterToInteractorProtocol: class,FetchProductProtocol,SaveProductToDatabaseProtocol {
    
    var presenter:InteractorToPresenterProtocol? {get set}
    var dataSources:[Product] { get set}
    var message:String? { get}
    func remove(product: Product)
    var isAllDataReceived:Bool { get set}
    
}

protocol InteractorToPresenterProtocol: class,LoadingIndicatorProtocol {
    
    func productFetched()
    func productFetchedFailure()
}








