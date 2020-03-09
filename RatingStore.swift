//
//  RatingStore.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class RatingStore {
    
    static let sharedInstnce = RatingStore()
    private init() {}
    
    var ratings: [Rating] = []
}
