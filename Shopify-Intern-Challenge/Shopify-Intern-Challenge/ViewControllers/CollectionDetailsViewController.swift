//
//  CollectionDetailsViewController.swift
//  Shopify-Intern-Challenge
//
//  Created by Michael Ding on 2019-01-08.
//  Copyright © 2019 MDing. All rights reserved.
//

import UIKit

class CollectionDetailsViewController: UIViewController {
    
    // MARK: -- IBOutlets
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var collectionDescriptionView: UIView!
    
    // MARK: - Properties
    var collectionID = 0
    var selectedCollectionData: CustomCollection?
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initiateProductsTableView()
        // Grabs specific products associated with selected collection
        ShopifyAPIService.main.getCollection(for: collectionID) { productData in
            self.products = productData
            self.productsTableView.reloadData()
        }
    }
    
}

// MARK: -- Handles productsTableView delegate & datasource
extension CollectionDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath) as! ProductTableViewCell
        cell.productNameLabel.text = products[indexPath.row].productName
        cell.productQuantityLabel.text = "\(products[indexPath.row].availableInventory) left in stock"
        
        if let collectionName = selectedCollectionData?.collectionName {
            cell.collectionNameLabel.text = "\(collectionName)"
        }
        
        return cell
    }
    
    fileprivate func initiateProductsTableView() {
        productsTableView.delegate = self
        productsTableView.dataSource = self
    }
    
}
