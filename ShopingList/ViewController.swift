//
//  ViewController.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        ServiceProvider().fetchProducts { (success,response) in
            
        } failureCallback: { (message) in
            
        }
        
    }
    
    
}

