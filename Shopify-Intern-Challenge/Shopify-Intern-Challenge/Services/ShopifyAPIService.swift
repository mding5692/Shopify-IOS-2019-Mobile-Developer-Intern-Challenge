//
//  ShopifyAPIService.swift
//  Shopify-Intern-Challenge
//
//  Created by Michael Ding on 2019-01-08.
//  Copyright © 2019 MDing. All rights reserved.
//

import Foundation
import Alamofire

// MARK: -- Specifies type of shopify data we're collecting
enum ShopifyDataType: String {
    case custom_collections, collects, products
}

// MARK: -- Strings for Shopify API Endpoints
enum ShopifyURLStrings: String {
    case baseURL = "https://shopicruit.myshopify.com/admin/"
    case custom_collections = "custom_collections.json"
    case collects = "collects.json"
    case products = "products.json"
    case accessToken = "c32313df0d0ef512ca64d5b336a0d7c6"
}

// MARK: -- Singleton class for grabbing Shopify Collections Data
class ShopifyAPIService {
    
    // MARK: -- Properties
    static let main = ShopifyAPIService(baseURLString: ShopifyURLStrings.baseURL.rawValue)
    var shopifyBaseURL = String()

    // MARK: -- Initialization
    fileprivate init(baseURLString: String) {
        self.shopifyBaseURL = baseURLString
    }
    
    // MARK: -- Methods
    
    func getCustomCollections(completion: @escaping (_ collectionsData: [CustomCollection]) -> Void) {
        // Generates an endpoint to grab collection data from
        let collectionsEndPoint = "\(shopifyBaseURL)\(ShopifyURLStrings.custom_collections.rawValue)?access_token=\(ShopifyURLStrings.accessToken.rawValue)"
        // Grabs collection data from Shopify API using Alamofire
        AF.request(collectionsEndPoint, method: .get).responseJSON { response in
            guard let data = response.result.value as? [String: Any],
            let collectionData = data[ShopifyDataType.custom_collections.rawValue] as? [[String: Any]] else {
                print("Error: Unable to grab or parse Shopify collections data")
                return
            }
            
            // Converts raw Shopify collection data into our CustomCollection format
            var customCollectionResults = [CustomCollection]()
            for collection in collectionData {
                guard let id = collection["id"] as? Int,
                let title = collection["title"] as? String,
                let img = collection["image"] as? [String: Any],
                let bodyHTML = collection["body_html"] as? String,
                let imgURLString = img["src"] as? String else {
                        continue
                }
                
                let name = title.components(separatedBy: " ")[0]
                guard let imgURL = URL(string: imgURLString) else {
                    continue
                }
                
                let customCollection = CustomCollection(collectionName: name, collectionID: id, collectionImgURL: imgURL, collectionTitle: title, collectionDescription: bodyHTML)
                customCollectionResults.append(customCollection)
            }
            
            completion(customCollectionResults)
        }
    }
    
    func getCollection(for collectionID: Int, completion: @escaping (_ collectionData: [Product]) -> Void) {
        // Generates end point to figure out which products are included
        let collectsEndPoint = "\(shopifyBaseURL)\(ShopifyURLStrings.collects.rawValue)?collection_id=\(collectionID)&access_token=\(ShopifyURLStrings.accessToken.rawValue)"
        
        // Grabs collection data from Shopify API using Alamofire
        AF.request(collectsEndPoint, method: .get).responseJSON { response in
            guard let data = response.result.value as? [String: Any],
                let collectionData = data[ShopifyDataType.collects.rawValue] as? [[String: Any]] else {
                    print("Error: Unable to grab or parse collection data for \(collectionID)")
                    return
            }
            
            // Grabs productsIDs from collection data and turns into one string for querying
            var productIDsKey = ""
            for productData in collectionData {
                guard let productID = productData["product_id"] as? Int else {
                    continue
                }
                productIDsKey += "\(productID),"
            }
            // Removes last comma because not needed
            productIDsKey.removeLast()
            
            // Grabs product details from Shopify based on product IDs and converts into easy-to-read format
            self.getProductData(for: productIDsKey) { products in
                completion(products)
            }
    
        }
    }
    
    func getProductData(for productIDs: String, completion: @escaping (_ productDetails: [Product]) -> Void) {
        // Generates endpoint to query product details
        let productsEndPoint = "\(shopifyBaseURL)\(ShopifyURLStrings.products.rawValue)?ids=\(productIDs)&access_token=\(ShopifyURLStrings.accessToken.rawValue)"
        
        // Grabs product details from Shopify API
        AF.request(productsEndPoint, method: .get).responseJSON { response in
            guard let data = response.result.value as? [String: Any],
                let productData = data[ShopifyDataType.products.rawValue] as? [[String: Any]] else {
                    print("Error: Unable to grab or parse product data for \(productIDs)")
                    return
            }
            
            // Parses product data grabbed from Shopify
            var productResults = [Product]()
            for product in productData {
                guard let id = product["id"] as? Int,
                let name = product["title"] as? String,
                let type = product["product_type"] as? String,
                    let variants = product["variants"] as? [[String: Any]] else {
                        continue
                }
                // Calculates total inventory from all variants
                var availableInventory = 0
                for variant in variants {
                    guard let quantity = variant["inventory_quantity"] as? Int,
                        quantity > 0 else {
                            continue
                    }
                    availableInventory += quantity
                }
                
                let productDetails = Product(productName: name, productID: id, availableInventory: availableInventory, numOfVariants: variants.count, productType: type)
                productResults.append(productDetails)
            }
            
            completion(productResults)
        }
    }

}
