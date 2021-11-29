//
//  ConnectivityChecker.swift
//  ShopingList
//
//  Created by Sureshkumar Linganathan on 29/11/21.
//

import Foundation

class ConnectionManager {
    
    static let shared = ConnectionManager()
    private init () {}
    
    func hasConnectivity() -> Bool {
        do {
            let reachability: Reachability = try Reachability()
            let networkStatus = reachability.connection
            
            switch networkStatus {
            case .unavailable:
                return false
            case .wifi, .cellular:
                return true
            }
        }
        catch {
            return false
        }
    }
}
