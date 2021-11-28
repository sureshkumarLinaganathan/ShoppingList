//
//  CartRouter.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import Foundation
import UIKit

class CartListRouter:CartListPresenterToRouterProtocol{
    
    static func createModule() -> CartListViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "CartListControllerID") as! CartListViewController
        return view
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
