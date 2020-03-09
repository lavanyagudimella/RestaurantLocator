//
//  BookingTableViewController.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class BookingTableViewController: UITableViewController {
    
    var store = DataStore.sharedInstnce

    override func viewDidLoad() {
        super.viewDidLoad()
        if Reach.isConnectedToNetwork() == true
        {
            print("Connected")
        }
        else
        {
            let controller = UIAlertController(title: "No WiFi Connection", message: "Please turn on the the WiFi to access the bookings", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            controller.addAction(cancel)
            present(controller, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.store.restaurantBookings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier",
                                                 for: indexPath) as! BookingTableViewCell
        cell.userNameLabel.text = self.store.restaurantBookings[indexPath.row].user
        cell.restaurantNameLabel.text = self.store.restaurantBookings[indexPath.row].restaurant
        cell.arrivalTimeLabel.text = self.store.restaurantBookings[indexPath.row].time
        cell.seatsBookedLabel.text = String(self.store.restaurantBookings[indexPath.row].seats)
        cell.arrivalDateLabel.text = String(describing: self.store.restaurantBookings[indexPath.row].date)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.restaurantBookings.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}
