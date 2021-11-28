//
//  PaginationCollectionViewCell.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 28/11/21.
//

import UIKit

class PaginationCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    static let identifier = "PaginationCellIdentifier"
    
    func setupView(){
        
        setupUI()
    }
    
    func startAnimation(){
        
        activityIndicator.startAnimating()
    }
    
    func stopAimnation (){
        
        activityIndicator.stopAnimating()
    }
    
}

extension PaginationCollectionViewCell{
    
    private func setupUI(){
        
        self.layoutIfNeeded()
        parentView.makeRoundCorner(radius:10.0)
        parentView.dropShadow(color: .lightGray, radius:3.0, offset:.zero)
    }
}
