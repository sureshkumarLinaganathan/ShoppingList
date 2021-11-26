//
//  WebService.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import Foundation

typealias successCallback = (Bool,AnyObject) -> Void
typealias failureCallback = (String)->Void

class WebService {
    
    class func initiateServiceCall(headers: [String: String]?, withMethod method :HttpMethod, urlStr: String, enableCache : Bool = false, requestObj : Data?, successCallBack : @escaping successCallback, failureCallback: @escaping failureCallback) -> URLSessionDataTask? {
        
        let request = constructRequest(headers:headers, requestData:requestObj, withMethod:method, urlStr:urlStr)
        return WebService.makeServiceCall(request:request, successCallBack: { (success,response) in
            successCallBack(success,response)
        }) { (errorMsg) in
            failureCallback(errorMsg)
        }
    }
}

private extension WebService{
    
    class private func constructRequest (headers: [String: String]?, requestData: Data?, withMethod method : HttpMethod,urlStr: String, enableCache : Bool = false) -> URLRequest {
        var urlStr = urlStr.replacingOccurrences(of: " ", with: "%20", options: .caseInsensitive, range: nil)
        urlStr = urlStr.replacingOccurrences(of: "#", with: "%23", options: .caseInsensitive, range: nil)
        urlStr = urlStr.replacingOccurrences(of: "\t", with: "%20", options: .caseInsensitive, range: nil)
        var request: URLRequest!
        let url:URL = URL.init(string:urlStr)!
        request = URLRequest.init(url:url)
        request.httpMethod = method.rawValue
        
        if (method == .post || method == .put || method == .delete), let data = requestData {
            request.httpBody = data
        }
        
        request.allHTTPHeaderFields = headers
        return request
    }
}

private extension WebService{
    
    class private func makeServiceCall(request : URLRequest,successCallBack : @escaping successCallback,failureCallback : @escaping failureCallback) -> URLSessionDataTask? {
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
            let tempResponse = response as? HTTPURLResponse
            let statusCode = String.init(format: "%d", tempResponse?.statusCode ?? 0)
            if statusCode == "200" {
                
                if data?.count != 0 {
                    
                    successCallBack(true,data as AnyObject)
                }else{
                    failureCallback("Incorrect data format.")
                }
            }else{
                if let wrapdata = data,wrapdata.count>0{
                    
                    do{
                        let json = try JSONSerialization.jsonObject(with:wrapdata, options:[])
                        if let dict = json as? [String:Any],let arr = dict["errors"] as? [[String:Any]],arr.count>0,let errorDict = arr.first,let message = errorDict["message"] as? String{
                            
                            failureCallback(message)
                        }
                    }catch{
                        failureCallback("Something went wrong. Please try again!")
                    }
                    
                }else{
                    failureCallback(error?.localizedDescription ?? "")
                }
            }
            
        })
        dataTask.resume()
        return dataTask
    }
}












