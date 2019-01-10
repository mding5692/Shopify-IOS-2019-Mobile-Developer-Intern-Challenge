//
//  CollectionDetailsViewController.swift
//  Shopify-Intern-Challenge
//
//  Created by Michael Ding on 2019-01-08.
//  Copyright © 2019 MDing. All rights reserved.
//

import UIKit
import Kingfisher

// MARK: -- For missing content in Collection Descriptions
enum MissingContentWarning: String {
    case noCollectionTitle = "No collection title set right now"
    case noCollectionDescription = "No collection description set right now"
}

class CollectionDetailsViewController: UIViewController {
    
    // MARK: -- IBOutlets
    @IBOutlet weak var productsTableView: UITableView!
    @IBOutlet weak var collectionDescriptionView: UIView!
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var collectionTitleLabel: UILabel!
    @IBOutlet weak var collectionDescriptionLabel: UILabel!
    
    // MARK: - Properties
    var collectionID = 0
    var selectedCollectionData: CustomCollection?
    var products = [Product]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initiateProductsTableView()
        fillsOutCollectionDescription()
        loadCollectionData()
    }
    
    fileprivate func loadCollectionData() {
        // Grabs specific products associated with selected collection
        DispatchQueue.global(qos: .userInteractive).async {
            ShopifyAPIService.main.getCollection(for: self.collectionID) { productData in
                self.products = productData
                DispatchQueue.main.async {
                    self.productsTableView.reloadData()
                }
            }
        }
    }
    
    fileprivate func fillsOutCollectionDescription() {
        // Gives users warning if missing collection title or description
        collectionTitleLabel.text = selectedCollectionData?.collectionTitle ?? MissingContentWarning.noCollectionTitle.rawValue
        collectionDescriptionLabel.text = selectedCollectionData?.collectionDescription ?? MissingContentWarning.noCollectionDescription.rawValue
        
        if let title = selectedCollectionData?.collectionTitle,
            title.isEmpty {
            collectionTitleLabel.text = MissingContentWarning.noCollectionTitle.rawValue
        }
        
        if let desc = selectedCollectionData?.collectionDescription,
            desc.isEmpty {
            collectionDescriptionLabel.text = MissingContentWarning.noCollectionDescription.rawValue
        }
        
        if let collectionImgURL = selectedCollectionData?.collectionImgURL {
            collectionImageView.kf.setImage(with: collectionImgURL)
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
        
        if let collectionName = selectedCollectionData?.collectionName,
            let collectionImgURL = selectedCollectionData?.collectionImgURL {
            cell.collectionNameLabel.text = "\(collectionName)"
            cell.collectionImageView.kf.setImage(with: collectionImgURL)
        }
        
        return cell
    }
    
    fileprivate func initiateProductsTableView() {
        productsTableView.delegate = self
        productsTableView.dataSource = self
    }
    
}
