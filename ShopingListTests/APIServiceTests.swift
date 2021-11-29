//
//  APIServiceTests.swift
//  GitHub AppTests
//
//  Created by Sureshkumar Linganathan on 28/10/21.
//

import XCTest
@testable import ShopingList

class APIServiceTests: XCTestCase {
    
    var serviceProvider:ServiceProvider?
    var databaseServiceProvider:DatabaseServiceProvider?
    let limit = 10
    let skip = 0
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        serviceProvider = ServiceProvider()
        databaseServiceProvider = DatabaseServiceProvider()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        serviceProvider = nil
        databaseServiceProvider = nil
    }
    func test_fetch_product_list_from_api(){
        
        let serviceProvider = self.serviceProvider
        let expect = XCTestExpectation(description: "callback")
        serviceProvider?.fetchProducts(limit:limit, skip:skip, successCallback: { (success,response) in
            
            expect.fulfill()
            XCTAssertNotNil(response)
            
        }, failureCallback: { (msg) in
            XCTAssertNotNil(msg)
            expect.fulfill()
        })
        
        wait(for: [expect], timeout:30.0)
    }
    
    func test_fetch_product_list_from_database(){
        
        let expect = XCTestExpectation(description: "callback")
        
        databaseServiceProvider?.fetchProducts(limit:10, skip:10, successCallback: { (success,response) in
            
            expect.fulfill()
            XCTAssertNotNil(response)
            
        }, failureCallback: { (message) in
            
            XCTAssertNotNil(message)
            expect.fulfill()
        })
    }
}
