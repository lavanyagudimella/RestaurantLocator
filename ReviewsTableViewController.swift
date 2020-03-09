//
//  ReviewsTableViewController.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/1/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class ReviewsTableViewController: UITableViewController {
    
    var store = RatingStore.sharedInstnce
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reach.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "No WiFi Connection", message: "Please turn on the the WiFi to access the reviews", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancel)
            present(controller, animated: true, completion: nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.ratings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! RatingTableViewCell
        cell.usernameLabel.text = self.store.ratings[indexPath.row].user
        cell.restaurantNameLabel.text = self.store.ratings[indexPath.row].restaurant
        cell.feedbackLabel.text = self.store.ratings[indexPath.row].feedback
        print(self.store.ratings[indexPath.row].rating)
        for each in cell.ratingLabel {
            if each.tag <= self.store.ratings[indexPath.row].rating {
                each.text = "★"
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.ratings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
