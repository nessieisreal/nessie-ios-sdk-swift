//
//  Purchase.swift
//  Nessie-iOS-Wrapper
//
//  Created by Lopez Vargas, Victor R. on 10/5/15.
//  Copyright (c) 2015 Nessie. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Purchase: JsonParser {
    public let merchantId: String
    public let status: String?
    public let medium:TransactionMedium
    public let payerId: String?
    public let amount: Int
    public let type: String?
    public var purchaseDate: NSDate?
    public let description: String?
    public let purchaseId: String
    
    public init(merchantId: String, status: String?, medium: TransactionMedium, payerId: String?, amount: Int, type: String, purchaseDate: NSDate?, description: String?, purchaseId: String) {
        self.merchantId = merchantId
        self.status = status
        self.medium = medium
        self.payerId = payerId
        self.amount = amount
        self.type = type
        self.purchaseDate = purchaseDate
        self.description = description
        self.purchaseId = purchaseId
    }
    
    public required init(data: JSON) {
        self.merchantId = data["merchant_id"].string ?? ""
        self.status = data["status"].string
        self.medium = TransactionMedium(rawValue: data["medium"].string ?? "") ?? .Unknown
        self.payerId = data["payer_id"].string
        self.amount = data["amount"].int ?? 0
        self.type = data["type"].string ?? ""
        let transactionDateString = data["purchase_date"].string
        if let str = transactionDateString {
            if let date = dateFormatter.dateFromString(str) {
                self.purchaseDate = date
            } else {
                self.purchaseDate = NSDate()
            }
        }
        self.description = data["description"].string
        self.purchaseId = data["_id"].string ?? ""
    }
}

public class PurchaseRequest {
    private var requestType: HTTPType!
    private var accountId: String?
    private var depositId: String?
    
    public init () {}
    
    private func buildRequestUrl() -> String {
        
        var requestString = "\(baseString)/deposits/"
        if let accountId = accountId {
            requestString = "\(baseString)/accounts/\(accountId)/deposits"
        }
        
        if let depositId = depositId {
            requestString += "\(depositId)"
        }
        
        requestString += "?key=\(NSEClient.sharedInstance.getKey())"
        
        return requestString
    }
    
    // APIs
    public func getDeposit(depositId: String, completion: (deposit: Deposit?, error: NSError?) -> Void) {
        requestType = HTTPType.GET
        self.depositId = depositId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: requestType)
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(deposit: nil, error: error)
            } else {
                let json = JSON(data: data!)
                let response = BaseResponse<Deposit>(data: json)
                completion(deposit: response.object, error: nil)
            }
        })
    }
    
    public func getDepositsFromAccountId(accountId: String, completion: (depositArrays: Deposit?, error: NSError?) -> Void) {
        requestType = HTTPType.GET
        self.accountId = accountId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: requestType)
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(depositArrays: nil, error: error)
            } else {
                let json = JSON(data: data!)
                let response = BaseResponse<Deposit>(data: json)
                completion(depositArrays: response.object, error: nil)
            }
        })
    }
    
    public func postDeposit(newDeposit: Deposit, completion: (depositResponse: BaseResponse<Deposit>?, error: NSError?) -> Void) {
        requestType = HTTPType.POST
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: self.requestType)
        
        var params: Dictionary<String, AnyObject> = ["medium": newDeposit.medium.rawValue,
                                                     "amount": newDeposit.amount]
        if let transactionDate = newDeposit.transactionDate {
            params["transaction_date"] = transactionDate
        }
        if let description = newDeposit.description {
            params["description"] = description
        }
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        } catch let error as NSError {
            request.HTTPBody = nil
            completion(depositResponse: nil, error: error)
        }
        
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(depositResponse: nil, error: error)
            } else {
                let json = JSON(data: data!)
                let response = BaseResponse<Deposit>(data: json)
                completion(depositResponse: response, error: nil)
            }
        })
    }
    
    public func putDeposit(updatedDeposit: Deposit, completion: (depositResponse: BaseResponse<Deposit>?, error: NSError?) -> Void) {
        requestType = HTTPType.PUT
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: self.requestType)
        
        var params: Dictionary<String, AnyObject> = ["medium": updatedDeposit.medium.rawValue,
                                                     "amount": updatedDeposit.amount]
        if let transactionDate = updatedDeposit.transactionDate {
            params["transaction_date"] = transactionDate
        }
        if let description = updatedDeposit.description {
            params["description"] = description
        }
        
        do {
            request.HTTPBody = try NSJSONSerialization.dataWithJSONObject(params, options: [])
        } catch let error as NSError {
            request.HTTPBody = nil
            completion(depositResponse: nil, error: error)
        }
        
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(depositResponse: nil, error: error)
            } else {
                let json = JSON(data: data!)
                let response = BaseResponse<Deposit>(data: json)
                completion(depositResponse: response, error: nil)
            }
        })
    }
    
    public func deleteDeposit(depositId: String, completion: (depositResponse: BaseResponse<Deposit>?, error: NSError?) -> Void) {
        requestType = HTTPType.DELETE
        self.depositId = depositId
        
        let nseClient = NSEClient.sharedInstance
        let request = nseClient.makeRequest(buildRequestUrl(), requestType: self.requestType)
        nseClient.loadDataFromURL(request, completion: {(data, error) -> Void in
            if (error != nil) {
                completion(depositResponse: nil, error: error)
            } else {
                let response = BaseResponse<Deposit>(requestArray: nil, object: nil, message: "Deposit deleted")
                completion(depositResponse: response, error: nil)
            }
        })
    }
}
