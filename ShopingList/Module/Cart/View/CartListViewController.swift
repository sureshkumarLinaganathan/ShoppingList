//
//  CartViewController.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import UIKit

class CartListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var messageLabel: UILabel!
    
    var presenter:ViewToPresenterProtocol?
    
    private var loadingIndicator = LoadingIndicator()
    var dataSources = [Product](){
        
        didSet{
            collectionView.reloadData()
        }
    }
    private let pageSize = 10
    private var skip = 0
    private let CELL_INSET = 10
    private var isPaginationServiceRunning = false
    private var isAllDataReceived = false
    private let numberOfColumns = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchProducts(pageSize:pageSize, skip:skip)
        showMessageLabel(show:dataSources.count == 0)
    }
}

extension CartListViewController{
    
    private func setupView(){
        
        setTitle()
        addCell()
        setupLoadingIndicator()
    }
    
    private func addCell(){
        
        collectionView.register(UINib(nibName:ProductCollectionViewCell.name, bundle:nil), forCellWithReuseIdentifier:ProductCollectionViewCell.identifier)
        collectionView.register(UINib(nibName:PaginationCollectionViewCell.name, bundle:nil), forCellWithReuseIdentifier:PaginationCollectionViewCell.identifier)
    }
    
    private func setTitle(){
        
        self.title = "Cart List"
    }
    
    private func showAlert(message:String){
        
        let alertController = UIAlertController(title:"", message:message, preferredStyle:.alert)
        let okayAction = UIAlertAction(title:"OK", style:.default) { (action) in
            alertController.dismiss(animated:true, completion: nil)
        }
        alertController.addAction(okayAction)
        self.present(alertController, animated:true, completion: nil)
    }
    
    private func setupLoadingIndicator(){
        
        loadingIndicator = loadingIndicator.initWithView(view:self.view)
        self.view.addSubview(loadingIndicator)
    }
}

extension CartListViewController{
    
    private func fetchProducts(pageSize:Int,skip:Int){
        
        presenter?.fetchProduct(limit:pageSize, skip:skip)
    }
}

extension CartListViewController:PresenterToViewProtocol{
    
    func showProductList(products: [Product]) {
        
        skip = skip+pageSize
        isPaginationServiceRunning = false
        dataSources.append(contentsOf: products)
    }
    
    func showErrorMessage(message: String) {
        showAlert(message:message)
    }
    
    func sendAllDataReceivedStatus(status: Bool) {
        isAllDataReceived = status
    }
    
}


extension CartListViewController:LoadingIndicatorProtocol{
    
    func showLoadingIndicator() {
        
        loadingIndicator.startAnimation()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.stopAnimation()
    }
}


extension CartListViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataSources.count > 0 && !isAllDataReceived{
            return  dataSources.count+1
        }
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == dataSources.count && !isAllDataReceived{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:PaginationCollectionViewCell.identifier, for:indexPath) as! PaginationCollectionViewCell
            cell.setupView()
            cell.startAnimation()
            
            if (!isPaginationServiceRunning){
                
                fetchProducts(pageSize:pageSize, skip:skip)
            }
            
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ProductCollectionViewCell.identifier, for:indexPath) as! ProductCollectionViewCell
            cell.setupView(product:dataSources[indexPath.row])
            cell.showRemoveCartOption()
            cell.removeCartDelegate = self
            return cell
        }
    }
    
}

extension CartListViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        let spacing = CGFloat((2 * CELL_INSET)/numberOfColumns)
        
        if indexPath.row == dataSources.count && !isAllDataReceived{
            
            let cellSize = CGSize(width: (collectionView.bounds.width - spacing), height:PaginationCollectionViewCell.height)
            return cellSize
            
        }else{
            
            let cellSize = CGSize(width: (collectionView.bounds.width - spacing), height:ProductCollectionViewCell.height)
            return cellSize
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return CGFloat(CELL_INSET)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        
        let inset = CGFloat(CELL_INSET)
        let sectionInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        return sectionInset
    }
}

extension CartListViewController:RemoveCartOptionProtocol{
    
    func didTappedRemoveCartButton(cell: ProductCollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for:cell) else{
            return
        }
        
        var product = dataSources[indexPath.row ]
        product.isAddedToCart = false
        presenter?.addProductToDatabase(product:product)
        dataSources.remove(at:indexPath.row)
        showMessageLabel(show:dataSources.count == 0)
    }
    
    private func showMessageLabel(show:Bool){
        
        if show{
            messageLabel.isHidden = false
        }else{
            messageLabel.isHidden = true
        }
        
    }
}

