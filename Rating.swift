//
//  Ratings.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class Rating: NSObject, NSCoding {
    
    struct rating {
        static let UserName = "uname"
        static let RestaurantName = "rname"
        static let Userfeedback = "feed"
        static let Rating = ""
    }
    
    private var username = String()
    private var restaurantname = String()
    private var userfeedback = String()
    private var userrating = Int()
    
    init(uname:String, rname:String, feedback: String, rating: Int) {
        self.username = uname
        self.restaurantname = rname
        self.userfeedback = feedback
        self.userrating = rating
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let unameObj =  aDecoder.decodeObject(forKey: rating.UserName) as? String {
            username = unameObj
        }
        
        if let rnameObj =  aDecoder.decodeObject(forKey: rating.RestaurantName) as? String {
            restaurantname = rnameObj
        }
        
        if let feedbackObj = aDecoder.decodeObject(forKey: rating.Userfeedback) as? String {
            userfeedback = feedbackObj
        }
        
        if let ratingObj = aDecoder.decodeObject(forKey: rating.Rating) as? Int {
            userrating = ratingObj
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: rating.UserName)
        aCoder.encode(restaurantname, forKey: rating.RestaurantName)
        aCoder.encode(userfeedback, forKey: rating.Userfeedback)
        aCoder.encode(userrating, forKey: rating.Rating)
    }
    
    var user : String {
        get {
            return username
        }
        set {
            username = newValue;
        }
    }
    
    var  restaurant : String {
        get {
            return restaurantname
        }
        set {
            restaurantname = newValue;
        }
    }
    
    var  feedback : String {
        get {
            return userfeedback
        }
        set {
            userfeedback = newValue;
        }
    }
    
    var  rating : Int {
        get {
            return userrating
        }
        set {
            userrating = newValue;
        }
    }
}
