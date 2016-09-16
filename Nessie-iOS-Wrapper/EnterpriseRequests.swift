//
//  EnterpriseRequests.swift
//  Nessie-iOS-Wrapper
//
//  Created by Mecklenburg, William on 5/19/15.
//  Copyright (c) 2015 Nessie. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol Enterprise {
    var id: String? { get }
    var urlName: String { get }
    func buildRequestUrl() -> String
}

extension Enterprise {
    func buildRequestUrl() -> String {
        var requestString = "\(baseEnterpriseString)\(urlName)"
        if let id = id {
            requestString += "/\(id)"
        }
        requestString += "?key=\(NSEClient.sharedInstance.getKey())"
        return requestString
    }
}

public struct EnterpriseAccountRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "accounts"
    
    public init () {}
    
    public func getAccounts(completion:(accountsArray: Array<Account>?, error: NSError?) -> Void) {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(accountsArray: nil, error: error)
            } else {
                guard let data = data else {
                    completion(accountsArray: nil, error: genericError)
                    return
                }
                let json = JSON(data: data)
                let response = BaseResponse<Account>(data: json)
                completion(accountsArray: response.requestArray, error: nil)
            }
        })
    }
    
    public mutating func getAccount(accountId: String, completion: (customer: Account?, error: NSError?) -> Void) {
        self.id = accountId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(customer: nil, error: error)
            } else {
                let json = JSON(data: data!)
                let response = BaseResponse<Account>(data: json)
                completion(customer: response.object, error: nil)
            }
        })
    }
}

public struct EnterpriseBillRequest: Enterprise {
    var id: String? = nil
    var urlName: String = "bills"
    
    public init () {}
    
    public func getBills(completion:(billsArray: Array<Bill>?, error: NSError?) -> Void) {
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(billsArray: nil, error: error)
            } else {
                guard let data = data else {
                    completion(billsArray: nil, error: genericError)
                    return
                }
                let json = JSON(data: data)
                let response = BaseResponse<Bill>(data: json)
                completion(billsArray: response.requestArray, error: nil)
            }
        })
    }
    
    public mutating func getBill(bilId: String, completion: (customer: Bill?, error: NSError?) -> Void) {
        self.id = bilId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: .GET)
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(customer: nil, error: error)
            } else {
                let json = JSON(data: data!)
                let response = BaseResponse<Bill>(data: json)
                completion(customer: response.object, error: nil)
            }
        })
    }
}
