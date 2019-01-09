//
//  ViewController.swift
//  Shopify-Intern-Challenge
//
//  Created by Michael Ding on 2019-01-08.
//  Copyright © 2019 MDing. All rights reserved.
//

import UIKit

class CustomCollectionsListViewController: UIViewController {
    
    @IBOutlet weak var customCollectionsTableView: UITableView!
    var customCollectionsData = [CustomCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Grabs custom collections data from Shopify API and populates customCollectionsTableView
        initiateCustomCollectionsTableView()
        ShopifyAPIService.main.getCustomCollections() { collectionData in
            self.customCollectionsData = collectionData
            self.customCollectionsTableView.reloadData()
        }
    }

}

// MARK: -- Handles customCollectionsTableView delegate & datasource functions
extension CustomCollectionsListViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func initiateCustomCollectionsTableView() {
        customCollectionsTableView.delegate = self
        customCollectionsTableView.dataSource = self
        
        // Shadow and curved borders for tableView
        let containerView = UIView(frame: customCollectionsTableView.frame)
        containerView.backgroundColor = .clear
        containerView.layer.shadowColor = UIColor.darkGray.cgColor
        containerView.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        containerView.layer.shadowOpacity = 1.0
        containerView.layer.shadowRadius = 2
        
        customCollectionsTableView.layer.cornerRadius = 10
        customCollectionsTableView.layer.masksToBounds = true
        
        view.addSubview(containerView)
        containerView.addSubview(customCollectionsTableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customCollectionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath)
        cell.textLabel?.text = customCollectionsData[indexPath.row].collectionName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let collectionID = customCollectionsData[indexPath.row].collectionID
        
        ShopifyAPIService.main.getCollection(for: collectionID) { products in
            print(products)
        }
    }
    
}

