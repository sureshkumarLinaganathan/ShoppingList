//
//  ApiManager.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation


class ApiManager {
    
    
    class func fetchProducts(limit:Int,skip:Int,successCallback:@escaping successCallback,failureCallback:@escaping failureCallback){
        
        let (url,headers) = WebServiceConfig.getUrlWithHeaders(forActionType:.fetchMenu, forHeaderType:.basic, queryString:[:], apiType:.firstVersion,paths:nil)
        
        _ = WebService.initiateServiceCall(headers:headers, withMethod:.get, urlStr:url, requestObj:nil, successCallBack: { (success,response) in
            
            guard let data = response as? Data else{
                DispatchQueue.main.async {
                    failureCallback("Incorrect data format.")
                }
                return
            }
            
            do{
                
                let json = try JSONSerialization.jsonObject(with:data, options:[])
                
                guard let arr = json as? [[String:Any]] else{
                    DispatchQueue.main.async {
                        failureCallback("Incorrect data format.")
                    }
                    return
                }
                
                var  objs = Parser.decode(data:arr, type:[Product].self) as! [Product]
                objs = sliceProducts(products:objs, skip:skip, limit:limit)
                DispatchQueue.main.async {
                    successCallback(success,objs as AnyObject)
                }
                
                
            }catch{
                DispatchQueue.main.async {
                    failureCallback("Incorrect data format.")
                }
            }
            
        }, failureCallback: { (msg) in
            
            DispatchQueue.main.async {
                failureCallback(msg)
            }
            
        })
    }
    
}

extension ApiManager{
    
    private class func sliceProducts(products:[Product],skip:Int,limit:Int)->[Product]{
        
        let startValue = skip
        let endValue = startValue+limit
        
        if products.count >= startValue {
            
            let arr = products[startValue..<min(products.count,endValue)]
            return Array(arr)
        }
        return []
        
    }
}

