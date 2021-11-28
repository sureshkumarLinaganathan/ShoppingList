//
//  LoadingIndicator.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import UIKit

class LoadingIndicator: UIView {
    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func initWithView(view:UIView)->LoadingIndicator{
        
        let loadingIndicator = Bundle.main.loadNibNamed("LoadingIndicator", owner:self, options:nil)?.first as! LoadingIndicator
        loadingIndicator.center = view.center
        loadingIndicator.frame = view.frame
        loadingIndicator.isHidden = true
        loadingIndicator.setupUI()
        return loadingIndicator
    }
    
    private func setupUI(){
        
        parentView.makeRoundCorner(radius:10.0)
    }
    
    func startAnimation(){
        
        DispatchQueue.main.async {
            self.activityIndicator.startAnimating()
            self.isHidden = false
        }
        
    }
    
    func stopAnimation(){
        
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.isHidden = true
        }
    }
    
}
