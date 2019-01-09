//
//  ShopifyAPIService.swift
//  Shopify-Intern-Challenge
//
//  Created by Michael Ding on 2019-01-08.
//  Copyright © 2019 MDing. All rights reserved.
//

import Foundation
import Alamofire

enum ShopifyDataType: String {
    case custom_collections
}

// MARK: -- Singleton class for grabbing Shopify Collections Data

class ShopifyAPIService {
    
    // MARK: -- Properties
    static let main = ShopifyAPIService(baseURLString: "https://shopicruit.myshopify.com/admin/")
    var shopifyBaseURL = String()
    let collectionsURLString = "custom_collections.json"
    let collectURLString = "collects.json"
    let productsURLString = "products.json"
    let accessToken = "c32313df0d0ef512ca64d5b336a0d7c6"
    
    // MARK: -- Initialization
    fileprivate init(baseURLString: String) {
        self.shopifyBaseURL = baseURLString
    }
    
    // MARK: -- Methods
    func grabCollections(completion: @escaping (_ collectionData: [CustomCollection]) -> Void) {
        let collectsEndPoint = "\(shopifyBaseURL)\(collectionsURLString)?access_token=\(accessToken)"
        AF.request(collectsEndPoint, method: .get).responseJSON { response in
            guard let data = response.result.value as? [String: Any],
            let collectionData = data[ShopifyDataType.custom_collections.rawValue] as? [[String: Any]] else {
                print("Error: Unable to grab or parse Shopify Collect data")
                return
            }
            
            var customCollectionResults = [CustomCollection]()
            for collection in collectionData {
                guard let id = collection["id"] as? Int,
                let title = collection["title"] as? String,
                let img = collection["image"] as? [String: Any],
                let imgURLString = img["src"] as? String else {
                        continue
                }
                
                let name = title.components(separatedBy: " ")[0]
                guard let imgURL = URL(string: imgURLString) else {
                    continue
                }
                
                let customCollection = CustomCollection(collectionName: name, collectionID: id, collectionImgURL: imgURL, collectionTitle: title)
                customCollectionResults.append(customCollection)
            }
            
            completion(customCollectionResults)
        }
    }
    

}
