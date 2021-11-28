//
//  CartRouter.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import Foundation
import UIKit

class CartRouter:PresenterToRouterCartProtocol{
    
    static func createModule() -> CartViewController {
        
        let view = mainstoryboard.instantiateViewController(withIdentifier: "CartControllerID") as! CartViewController
        return view
    }
    
    static var mainstoryboard: UIStoryboard{
        return UIStoryboard(name:"Main",bundle: Bundle.main)
    }
}
