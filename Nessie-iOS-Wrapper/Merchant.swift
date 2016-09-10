//
//  Merchant.swift
//  Nessie-iOS-Wrapper
//
//  Created by Lopez Vargas, Victor R. (CONT) on 9/1/15.
//  Copyright (c) 2015 Nessie. All rights reserved.
//

import Foundation
import SwiftyJSON

public class Merchant: JsonParser {
    
    public let merchantId: String
    public let name: String
    public let category: Array<String>
    public let address: Address
    public let geocode: Geocode
    
    public init(merchantId: String, name: String, category: Array<String>, address: Address, geocode: Geocode) {
        self.merchantId = merchantId
        self.name = name
        self.category = category
        self.address = address
        self.geocode = geocode
    }
    
    public required init(data: JSON) {
        self.merchantId = data["merchantId"].string ?? ""
        self.name = data["name"].string ?? ""
        self.category = data["category"].arrayValue.map({$0.string ?? ""})
        self.address = Address(data: data["address"])
        self.geocode = Geocode(data: data["geocode"])
    }
}
