//
//  Booking.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit

class Booking: NSObject, NSCoding {
    
    struct booking {
        static let UserName = "uname"
        static let RestaurantName = "rname"
        static let arrivalTime = "time"
        static let BookedSeats = "seats"
        static let arrivalDate = "date"
    }
    
    private var username = ""
    private var restaurantname = ""
    private var arrivaltiming = ""
    private var bookedseats = ""
    private var arrivaldate = ""
    
    init(uname:String, rname:String, time:String, seats:String, arrivalDate:String) {
        self.username = uname
        self.restaurantname = rname
        self.arrivaltiming = time
        self.bookedseats = seats
        self.arrivaldate = arrivalDate
    }
    
    required init?(coder aDecoder: NSCoder) {
       if let unameObj =  aDecoder.decodeObject(forKey: booking.UserName) as? String {
            username = unameObj
        }
        
        if let rnameObj =  aDecoder.decodeObject(forKey: booking.RestaurantName) as? String {
            restaurantname = rnameObj
        }
        
        if let timeObj = aDecoder.decodeObject(forKey: booking.arrivalTime) as? String {
            arrivaltiming = timeObj
        }
        
        if let seatsObj = aDecoder.decodeObject(forKey: booking.BookedSeats) as? String {
            bookedseats = seatsObj
        }
        
        if let dateObj = aDecoder.decodeObject(forKey: booking.arrivalDate) as? String {
            arrivaldate = dateObj
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: booking.UserName)
        aCoder.encode(restaurantname, forKey: booking.RestaurantName)
        aCoder.encode(arrivaltiming, forKey: booking.arrivalTime)
        aCoder.encode(bookedseats, forKey: booking.BookedSeats)
        aCoder.encode(arrivaldate, forKey: booking.arrivalDate)
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
    
    var  time : String {
        get {
            return arrivaltiming
        }
        set {
            arrivaltiming = newValue;
        }
    }
    
    var  date : String {
        get {
            return arrivaldate
        }
        set {
            arrivaldate = newValue;
        }
    }
    
    var  seats : String {
        get {
            return bookedseats
        }
        set {
            bookedseats = newValue;
        }
    }
}
