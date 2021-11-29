//
//  MockService.swift
//  GitHub AppTests
//
//  Created by Sureshkumar Linganathan on 29/10/21.
//

import Foundation
@testable import ShopingList

class MockServices:ProductListServiceProviderProtocol {
    
    var responseType:MockApiResponseType = .success
    
    func fetchProducts(limit: Int, skip: Int, successCallback: @escaping successCallback, failureCallback: @escaping failureCallback) {
        
        switch responseType {
        
        case .success:
            
            let repo = Product(id:"1", name:"Chicken", image:"http://placeimg.com/640/480", description:"The slim & simple Maple Gaming Keyboard from Dev Byte comes with a sleek body and 7- Color RGB LED Back-lighting for smart functionality", price:"391.00", isAddedToCart:false)
            successCallback(true,[repo] as AnyObject)
            
        case .failure:
            
            failureCallback("Something went wrong!")
            
        case .successWithEmptyData:
            
            successCallback(true,[] as AnyObject)
            
        case .failureWithOutMsg:
            failureCallback("")
        case .loadingIndicatorStatus:
            successCallback(true,[] as AnyObject)
        default:
            failureCallback("Request Time out")
        }
    }
    
    
    
}

enum MockApiResponseType {
    
    case success
    case failure
    case successWithEmptyData
    case failureWithOutMsg
    case loadingIndicatorStatus
    case reloadStatus
    case timeOut
}


