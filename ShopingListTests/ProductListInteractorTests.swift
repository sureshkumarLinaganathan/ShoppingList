//
//  ProductListInteractorTests.swift
//  ShopingListTests
//
//  Created by Sureshkumar Linganathan on 29/11/21.
//

import XCTest
@testable import ShopingList

class ProductListInteractorTests: XCTestCase {
    
    var interactor:ProductListInteractor?
    var mockAPIService: MockServices!
    
    override func setUpWithError() throws {
        mockAPIService = MockServices()
        interactor = ProductListInteractor(serviceProvider:mockAPIService)
    }
    
    override func tearDownWithError() throws {
        
        mockAPIService = nil
        interactor =  nil
    }
    
    func test_fetch_prodcut_list() {
        
        mockAPIService.responseType = .success
        interactor?.fetchProduct(limit:1, skip:0)
        XCTAssertEqual(interactor?.dataSources.count,1)
    }
    
    func test_fetch_product_list_failure(){
        
        mockAPIService.responseType = .failure
        interactor?.fetchProduct(limit:1, skip:0)
        XCTAssertEqual(interactor?.message, "Something went wrong!")
    }
    
    func test_fetch_product_list_empty(){
        
        mockAPIService.responseType = .successWithEmptyData
        interactor?.fetchProduct(limit:1, skip:0)
        XCTAssertEqual(interactor?.dataSources.count,0)
        
    }
    
    func test_fetch_product_list_failure_with_empty_msg(){
        
        mockAPIService.responseType = .failureWithOutMsg
        interactor?.fetchProduct(limit:1, skip:0)
        XCTAssertEqual(interactor?.message,"")
    }
    
    func test_fetch_product_list_timeout(){
        
        mockAPIService.responseType = .timeOut
        interactor?.fetchProduct(limit:1, skip:0)
        XCTAssertEqual(interactor?.message,"Request Time out")
    }
}


