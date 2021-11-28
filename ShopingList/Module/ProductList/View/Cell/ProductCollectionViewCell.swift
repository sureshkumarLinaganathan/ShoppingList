//
//  ProductCollectionViewCell.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import UIKit
import SDWebImage


protocol ProductCollectionViewCellProtocol:class{
    
    func didTapCartButton(cell:ProductCollectionViewCell)
}

class ProductCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ProductListCellIdentifier"
    static let height:CGFloat = 340
    static let name = "ProductCollectionViewCell"
    
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var productDesLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    
    weak var delegate:ProductCollectionViewCellProtocol?
    
    func setupView(product:Product){
        
        setupUI()
        
        if let name = product.name{
            
            nameLabel.text = name
        }
        
        if let des = product.description{
            
            productDesLabel.text = des
        }
        
        if let price = product.price{
            
            priceLabel.text = "₹"+price
        }
        
        if let image = product.image{
            
            profileImageView.sd_setImage(with:URL(string: image)) { [weak self](image,error,type,url) in
                
                guard let img = image else{
                    
                    return
                }
                
                self?.profileImageView.image = img
            }
        }
        
        
    }
    
    @IBAction func addToCartButtonTapped(_ sender: Any) {
        
        self.delegate?.didTapCartButton(cell:self)
    }
    
}

extension ProductCollectionViewCell{
    
    private func setupUI(){
        
        self.layoutIfNeeded()
        parentView.makeRoundCorner(radius:10.0)
        parentView.dropShadow(color: .lightGray, radius:3.0, offset:.zero)
        
        profileImageView.makeRoundCorner(radius:profileImageView.bounds.height/2)
    }
}
