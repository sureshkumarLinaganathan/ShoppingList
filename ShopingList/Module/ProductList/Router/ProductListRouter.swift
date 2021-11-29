//
//  ProductListRouter.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation
import UIKit

class ProductListRouter:PresenterToRouterProtocol{
    
    static func createModule() -> ProductListViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "ProductListControllerID") as! ProductListViewController
        
        let presenter: ViewToPresenterProtocol & InteractorToPresenterProtocol  = ProductListPresenter()
        let interactor: PresenterToInteractorProtocol = ProductListInteractor(serviceProvider:ServiceProvider(), fallbackServiceProvider:ProductatDabaseServiceProvider())
        let router:PresenterToRouterProtocol = ProductListRouter()
        
        view.presentor = presenter
        presenter.view = view 
        presenter.router = router
        presenter.interactor = interactor
        interactor.presenter = presenter
        
        return view
        
    }
    
    func pushToCartScreen(navigationConroller: UINavigationController) {
        
        let view = CartListRouter.createModule()
        navigationConroller.pushViewController(view, animated:true)
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
    
    
    
}
