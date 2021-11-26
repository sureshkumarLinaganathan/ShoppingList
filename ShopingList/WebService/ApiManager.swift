//
//  ApiManager.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation


class ApiManager {
    
    
    class func fetchProducts(successCallback:@escaping successCallback,failureCallback:@escaping failureCallback){
        
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
                
                let objs = Parser.decode(data:arr, type:[Product].self)
                 print(objs)
                DispatchQueue.main.async {
                    successCallback(success,objs)
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

