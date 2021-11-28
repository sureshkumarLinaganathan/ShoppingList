//
//  ViewController.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import UIKit

class ProductListViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var presentor:ViewToPresenterProtocol?
    private var loadingIndicator = LoadingIndicator()
    
    private let limit = 10
    private var skip = 0
    private let CELL_INSET:CGFloat = 10
    var isPaginationServiceRunning = false
    
    var isPaginationEnabled:Bool{
        
        return dataSources.count%limit == 0
    }
    
    var dataSources = [Product](){
        
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchProductList(limit:limit, skip:skip)
    }
}


extension ProductListViewController{
    
    private func setupView(){
        
        addCell()
        setupLoadingIndicator()
    }
    
    private func addCell(){
        
        collectionView.register(UINib(nibName:"ProductCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:ProductCollectionViewCell.identifier)
        collectionView.register(UINib(nibName: "PaginationCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:PaginationCollectionViewCell.identifier)
    }
    
    private func setupLoadingIndicator(){
        
        loadingIndicator = loadingIndicator.initWithView(view:self.view)
        self.view.addSubview(loadingIndicator)
    }
}

extension ProductListViewController{
    
    private func fetchProductList(limit:Int,skip:Int){
        
        presentor?.fetchProduct(limit:limit, skip:skip)
    }
}


extension ProductListViewController{
    
    private func showAlert(message:String){
        
        let alertController = UIAlertController(title:"", message:message, preferredStyle:.alert)
        let okayAction = UIAlertAction(title:"OK", style:.default) { (action) in
            alertController.dismiss(animated:true, completion: nil)
        }
        alertController.addAction(okayAction)
        self.present(alertController, animated:true, completion: nil)
    }
}

extension ProductListViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if dataSources.count > 0 && isPaginationEnabled{
            return  dataSources.count+1
        }
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == dataSources.count && isPaginationEnabled{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:PaginationCollectionViewCell.identifier, for:indexPath) as! PaginationCollectionViewCell
            cell.setupView()
            cell.startAnimation()
            
            if (!isPaginationServiceRunning){
                
                isPaginationServiceRunning = true
                fetchProductList(limit:limit, skip:skip)
            }
            
            return cell
            
        }else{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:ProductCollectionViewCell.identifier, for:indexPath) as! ProductCollectionViewCell
            cell.setupView(product:dataSources[indexPath.row])
            return cell
        }
    }
    
}

extension ProductListViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        if indexPath.row == dataSources.count && isPaginationEnabled{
            
            let cellSize = CGSize(width: (collectionView.bounds.width - (3 * CELL_INSET))/1, height:50)
            return cellSize
            
        }else{
            
            let cellSize = CGSize(width: (collectionView.bounds.width - (3 * CELL_INSET))/2, height:340)
            return cellSize
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return CELL_INSET
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        let sectionInset = UIEdgeInsets(top: CELL_INSET, left: CELL_INSET, bottom: CELL_INSET, right: CELL_INSET)
        return sectionInset
    }
}

extension ProductListViewController:PresenterToViewProtocol{
    
    func showProductList(products: [Product]) {
        
        skip = skip+limit
        isPaginationServiceRunning = false
        dataSources.append(contentsOf: products)
    }
    
    func showErrorMessage(message: String) {
        
        showAlert(message:message)
    }
    
}

extension ProductListViewController:LoadingIndicatorProtocol{
    
    func showLoadingIndicator() {
        
        loadingIndicator.startAnimation()
    }
    
    func hideLoadingIndicator() {
        
        loadingIndicator.stopAnimation()
        
    }
}
