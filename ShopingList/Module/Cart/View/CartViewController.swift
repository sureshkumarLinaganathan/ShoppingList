//
//  CartViewController.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import UIKit

class CartViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    
}

extension CartViewController{
    
    private func setupView(){
        
        setTitle()
    }
    
    private func setTitle(){
        
        self.title = "Cart List"
    }
}
