//
//  WebServiceConfig.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 27/11/21.
//

import UIKit

enum HttpMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum UrlVersionType: String{
    case firstVersion = "v1"
}

enum ActionType : String {
    
    case fetchMenu = "menu"
}

struct ApiUrl {
    mutating func getBaseUrl(type: UrlVersionType)->String{
        switch type {
        
        default:
            return ApiIP.appIP_v1
        }
    }
}

struct ApiIP {
    static let appIP_v1 = "https://60d2fa72858b410017b2ea05.mockapi.io/api/v1/"
}

enum APIHeadersType {
    case basic
}

class WebServiceConfig {
    
    static let shared : WebServiceConfig = WebServiceConfig.init()
    
    class func requestHeaders(type: APIHeadersType) -> [String: String]? {
        switch type {
        case .basic:
            return ["Content-Type": "application/json"]
        }
    }
    
    class  func getUrlWithHeaders(forActionType type: ActionType, forHeaderType htype: APIHeadersType, queryString:[String:String], apiType: UrlVersionType,paths:[String]?) -> (String, [String: String]?) {
        let headerDict = WebServiceConfig.requestHeaders(type: htype)
        var apiUrl = ApiUrl()
        var baseUrl = apiUrl.getBaseUrl(type: apiType)
        
        if let arrPaths = paths{
            baseUrl += createPath(array:arrPaths)
        }
        baseUrl += type.rawValue
        if queryString.count > 0{
            baseUrl += WebServiceConfig.createQueryString(dict:queryString)
        }
        return (baseUrl,headerDict)
    }
    
    class func createQueryString(dict:[String:String])->String{
        var queryStr = "?"
        var count = 0
        for (key, value) in dict{
            if count >= 1{
                queryStr += "&"
            }
            queryStr = queryStr+key+"="+value
            count = count+1
        }
        return queryStr
    }
    
    class func createPath(array:[String])->String{
        
        var pathStr = ""
        var count = 0
        for str in array{
            
            if count >= 1{
                pathStr += "/"
            }
            pathStr += str
            count += 1
        }
        return pathStr
    }
}


