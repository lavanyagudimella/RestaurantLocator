//
//  RestaurantLocatorTests.swift
//  RestaurantLocatorTests
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import XCTest
@testable import RestaurantLocator

class RestaurantLocatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testisCoordinatesValid() {
        let mapVC = MapViewController()
        let latitude = -27.99824106
        let longitude = 153.42096322
        XCTAssertTrue(mapVC.isCoordinateValid(lat: latitude, lon: longitude),"Coordinates are Valid")
    }
    
    func testisCoordinatesInvalid() {
        let mapVC = MapViewController ()
        let latitude = -27.99824106
        let longitude = 153.42692297
        XCTAssert(mapVC.isCoordinateValid(lat: latitude, lon: longitude),"Coordinates are Invalid")
    }
    
    func testisCoordinatesparsesZero() {
        let mapVC = MapViewController()
        XCTAssert(mapVC.isCoordinateValid(lat: 0, lon: 0), "Coordinates parses Zero values")
    }
    
    func testisCoordinatesNil() {
        let mapVC = MapViewController()
        XCTAssertNil(mapVC.isCoordinateValid(lat: 0, lon: 0), "Cordinates are nil")
    }
    
    func testisCoordinatesNotNil() {
        let mapVC = MapViewController()
        XCTAssertNotNil(mapVC.isCoordinateValid(lat: 0, lon: 0), "Coordinates are not nil")
    }
    
    func testisCoordinatesparsesInvalidLine() {
        let mapVC = MapViewController()
        let latitude  = Double("2604;153.427")!
        let longitude = Double("2604;153.427")!
        XCTAssertFalse(mapVC.isCoordinateValid(lat: latitude, lon: longitude), "Coordinates parses an invalid Line")
    }
    
    func testisCoordinateswhenInputLinePoorlyFormatted() {
        let mapVC = MapViewController ()
        let latitude = Double("-32.78;76.12")!
        let longitude = Double("297;2010-07")!
        XCTAssertFalse(mapVC.isCoordinateValid(lat: latitude, lon: longitude) , "Coordinates are parsing inputs when poorly  formatted")
    }
}
