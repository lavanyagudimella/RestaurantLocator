//
//  TableViewController.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    final let UrlString = "https://data.melbourne.vic.gov.au/resource/erx6-js9z.json"
    
    var nameArray = [String]()
    var addressArray = [String]()
    var cityArray = [String]()
    var seatingCapcityArray = [String]()
    var seatingTypeArray = [String]()
    
    var value = String()
    var mapValue = String()
    var JSONArray = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        performJSONCaching(UrlString)
    }
    
    func loadList() {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    
    func performJSONCaching(_ link:String) {
        let url:URL = URL(string: link)!
        let request = URLRequest(url: url,
                                 cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringCacheData,
                                 timeoutInterval: 30)
        let cacheResponse = URLCache.shared.cachedResponse(for: request)
        if cacheResponse == nil {
            let config = URLSessionConfiguration.default
            config.urlCache = URLCache.shared
            let session = URLSession(configuration: config, delegate: self as? URLSessionDelegate, delegateQueue: nil)
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
                let cacheResponse = CachedURLResponse(response: response!, data: data!)
                URLCache.shared.storeCachedResponse(cacheResponse, for: request)
            })
            task.resume()
        } else {
            let cachedArray = NSString(data: cacheResponse!.data, encoding: String.Encoding.utf8.rawValue)
            JSONArray = cachedArray! as String
            self.extract_json(cacheResponse!.data)
        }
        //print("this is cached data")
    }

    func extract_json(_ data: Data) {
        let json: Any?
        do {
            json = try JSONSerialization.jsonObject(with: data, options: [])
        }
        catch {
            print("error serializing JSON: \(error)")
            return
        }
        
        guard let data_list = json as? NSArray else {
            return
        }
        
        if let restaurantsList = json as? NSArray {
            for i in 0 ..< data_list.count {
                if let restaurantsObj = restaurantsList[i] as? NSDictionary {
                
                    let restaurants = Restaurant()
                    
                    restaurants.restaurantName = (restaurantsObj["trading_name"] as? String)!
                    self.nameArray.append(restaurants.restaurantName)
                    
                    restaurants.restaurantAddress = (restaurantsObj["street_address"] as? String)!
                    self.addressArray.append(restaurants.restaurantAddress)
                    
                    restaurants.city = (restaurantsObj["clue_small_area"] as? String)!
                    self.cityArray.append(restaurants.city)
                    
                    restaurants.seatingCapacity = (restaurantsObj["number_of_seats"] as? String)!
                    self.seatingCapcityArray.append(restaurants.seatingCapacity)
                    
                    restaurants.seatingType = (restaurantsObj["seating_type"] as? String)!
                    self.seatingTypeArray.append(restaurants.seatingType)
                }
            }
        }
        self.loadList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
        
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! TableViewCell
        cell.restaurantNameLabel.text = nameArray[indexPath.row]
        cell.restaurantAddressLabel.text = addressArray[indexPath.row]
        cell.cityLabel.text = cityArray[indexPath.row]
        cell.seatingTypeLabel.text = seatingTypeArray[indexPath.row]
        cell.totalSeatsLabel.text = seatingCapcityArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "segueIdentifier", sender: (Any).self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueIdentifier" {
            let secondVC = segue.destination as! MakeBookingViewController
            secondVC.seatingCapacity = self.value
            if let indexPath = self.tableView.indexPathForSelectedRow
            {
                secondVC.seatingCapacity = seatingCapcityArray[indexPath.row]
                secondVC.restaurantNames = nameArray[indexPath.row]
            }
        }
    }
}
