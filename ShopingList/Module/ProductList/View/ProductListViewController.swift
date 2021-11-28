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
    
    private let pageSize = 10
    private var skip = 0
    private let CELL_INSET = 10
    private var isPaginationServiceRunning = false
    private let numberOfColumns = 1
    
    var isAllDataReceived = false
    
    var dataSources = [Product](){
        
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        fetchProductList(pageSize:pageSize, skip:skip)
    }
    
}


extension ProductListViewController{
    
    private func setupView(){
        
        addCell()
        setupLoadingIndicator()
        addCartButton()
        setTitle()
    }
    
    private func addCell(){
        
        collectionView.register(UINib(nibName:ProductCollectionViewCell.name, bundle:nil), forCellWithReuseIdentifier:ProductCollectionViewCell.identifier)
        collectionView.register(UINib(nibName:PaginationCollectionViewCell.name, bundle:nil), forCellWithReuseIdentifier:PaginationCollectionViewCell.identifier)
    }
    
    private func setupLoadingIndicator(){
        
        loadingIndicator = loadingIndicator.initWithView(view:self.view)
        self.view.addSubview(loadingIndicator)
    }
    
    private func showAlert(message:String){
        
        let alertController = UIAlertController(title:"", message:message, preferredStyle:.alert)
        let okayAction = UIAlertAction(title:"OK", style:.default) { (action) in
            alertController.dismiss(animated:true, completion: nil)
        }
        alertController.addAction(okayAction)
        self.present(alertController, animated:true, completion: nil)
    }
    
    private func addCartButton(){
        
        let cartButton = UIBarButtonItem(image: UIImage(named: "ic_cart"), style: .plain, target: self, action:#selector(addCartButtonTapped))
        self.navigationItem.rightBarButtonItem  =  cartButton
    }
    
    @objc private func addCartButtonTapped(){
        
        presentor?.pushToCartScreen(navigationConroller:self.navigationController ?? UINavigationController())
    }
    
    private func setTitle(){
        
        self.title = "Product List"
    }
}

extension ProductListViewController{
    
    private func fetchProductList(pageSize:Int,skip:Int){
        isPaginationServiceRunning = true
        presentor?.fetchProduct(limit:pageSize, skip:skip)
    }
}

extension ProductListViewController:UICollectionViewDataSource{
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
                
                fetchProductList(pageSize:pageSize, skip:skip)
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

extension ProductListViewController:PresenterToViewProtocol{
    
    func sendAllDataReceivedStatus(status: Bool) {
        
        isAllDataReceived = status
    }
    
    
    func showProductList(products: [Product]) {
        
        skip = skip+pageSize
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

extension ProductListViewController:ProductCollectionViewCellProtocol{
    
    func didTapCartButton(cell: ProductCollectionViewCell) {
        
        guard let indexPath = collectionView.indexPath(for:cell) else{
            return
        }
        
        var product = dataSources[indexPath.row ]
        product.isAddedToCart = true
        presentor?.addProductToDatabase(product:product)
        
    }
}
