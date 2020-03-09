//
//  DataStore.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class DataStore {
    
    static let sharedInstnce = DataStore()
    private init() {}
    var restaurantBookings: [Booking] = []
}
