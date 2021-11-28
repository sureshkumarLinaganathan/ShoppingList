//
//  CartViewController.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import UIKit

class CartListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presenter:ViewToPresenterProtocol?
    
    var dataSource = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

extension CartListViewController{
    
    private func setupView(){
        
        setTitle()
        addCell()
    }
    
    private func addCell(){
        
        collectionView.register(UINib(nibName:ProductCollectionViewCell.name, bundle:nil), forCellWithReuseIdentifier:ProductCollectionViewCell.identifier)
        collectionView.register(UINib(nibName:PaginationCollectionViewCell.name, bundle:nil), forCellWithReuseIdentifier:PaginationCollectionViewCell.identifier)
    }
    
    private func setTitle(){
        
        self.title = "Cart List"
    }
}

extension CartListViewController:PresenterToViewProtocol{
    
    func showProductList(products: [Product]) {
        
    }
    
    func showErrorMessage(message: String) {
        
    }
    
    func sendAllDataReceivedStatus(status: Bool) {
        
    }
    
    
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    
}
