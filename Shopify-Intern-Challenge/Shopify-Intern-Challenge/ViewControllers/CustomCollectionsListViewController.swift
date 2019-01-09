//
//  ViewController.swift
//  Shopify-Intern-Challenge
//
//  Created by Michael Ding on 2019-01-08.
//  Copyright © 2019 MDing. All rights reserved.
//

import UIKit

class CustomCollectionsListViewController: UIViewController {
    
    // MARK: -- IBOutlets
    @IBOutlet weak var customCollectionsTableView: UITableView!
    
    // MARK: -- Properties
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

// MARK: -- Handles customCollectionsTableView delegate, datasource & related functions
extension CustomCollectionsListViewController: UITableViewDelegate, UITableViewDataSource {
    fileprivate func initiateCustomCollectionsTableView() {
        customCollectionsTableView.delegate = self
        customCollectionsTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return customCollectionsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionCell", for: indexPath)
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = customCollectionsData[indexPath.row].collectionName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCollection = customCollectionsData[indexPath.row]
        
        // Sets data for collection details view controller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let collectionDetailsVC = storyboard.instantiateViewController(withIdentifier: "CollectionDetails") as! CollectionDetailsViewController
        collectionDetailsVC.title = selectedCollection.collectionName
        collectionDetailsVC.selectedCollectionData = selectedCollection
        collectionDetailsVC.collectionID = selectedCollection.collectionID
        
        self.navigationController?.pushViewController(collectionDetailsVC, animated: true)
    }
    
}

