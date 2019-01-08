//
//  ShopifyAPIService.swift
//  Shopify-Intern-Challenge
//
//  Created by Michael Ding on 2019-01-08.
//  Copyright © 2019 MDing. All rights reserved.
//

import Foundation
import Alamofire

// MARK: -- Singleton class for grabbing Shopify Collections Data

class ShopifyAPIService {
    
    // MARK: -- Properties
    static let main = ShopifyAPIService(baseURLString: "https://shopicruit.myshopify.com/admin/")
    var shopifyBaseURL = String()
    let collectionsURLString = "collects.json"
    let productsURLString = "products.json"
    let accessToken = "c32313df0d0ef512ca64d5b336a0d7c6"
    
    // MARK: -- Initialization
    fileprivate init(baseURLString: String) {
        self.shopifyBaseURL = baseURLString
    }
    
    // MARK: -- Methods
    fileprivate func grabCollectionLists(completion: (_ collectionData: [CustomCollection]) -> Void) {
        
    }
    

}
