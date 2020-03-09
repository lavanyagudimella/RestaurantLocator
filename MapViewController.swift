//
//  MapViewController.swift
//  RestaurantLocator
//
//  Created by Lavanya Palavancha on 6/3/17.
//  Copyright © 2017 Lavanya Palavancha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mymapView: MKMapView!
    
    var mapdata = String()
    
    var coords: CLLocationCoordinate2D?
    
    var locationManager = CLLocationManager()
    var userLocation = CLLocation()
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            mymapView.showsUserLocation = true
        } else {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mymapView.delegate = self
        mymapView.showsUserLocation = true
        checkLocationAuthorizationStatus()
        locationManager.delegate =  self
        
        print(mapdata)
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapdata) {
            placemarks, error in
            
            if error != nil {
                let alert = UIAlertController(title: "Network Access is Turned Off", message: "Turn on mobile data or use Wi-Fi to locate the Hospital", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                
                let placemark = placemarks![0]
                
                //let placemark = placemarks?.first
                let lat = placemark.location?.coordinate.latitude
                let lon = placemark.location?.coordinate.longitude
                
                print("\(String(describing: lat))")
                print("\(String(describing: lon))")
                
                let latitude : CLLocationDegrees = lat!
                let longitude:CLLocationDegrees = lon!
                
                let span:MKCoordinateSpan = MKCoordinateSpanMake(0.5,0.5)
                let hospitalLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude,longitude)
                let region: MKCoordinateRegion = MKCoordinateRegionMake(hospitalLocation, span)
                self.mymapView.setRegion(region, animated: true)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = hospitalLocation
                self.mymapView.addAnnotation(annotation)
                
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        self.getDirections(locations)
    }
    
    @IBAction func getDirections(_ sender: Any) {
        
        let locationManager = CLLocationManager()
        var currentLocation = CLLocation()
        
        currentLocation = locationManager.location!
        
        print("\(currentLocation.coordinate.longitude)")
        print("\(currentLocation.coordinate.latitude)")
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(mapdata) {
            placemarks, error in
            
            if error != nil {
                let alert = UIAlertController(title: "Network Access is Turned Off", message: "Turn on mobile data or use Wi-Fi to get directions to the Hospital", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                print("Geocode failed: \(error!.localizedDescription)")
            } else if placemarks!.count > 0 {
                
                let placemark = placemarks![0]
                
                //let placemark = placemarks?.first
                let lat = placemark.location?.coordinate.latitude
                let lon = placemark.location?.coordinate.longitude
                
                print("\(String(describing: lat))")
                print("\(String(describing: lon))")

                
                let destLatitude : CLLocationDegrees = lat!
                let destLongitude:CLLocationDegrees = lon!
                
                //let currentLat : CLLocationDegrees = currentLocation.coordinate.longitude
                //let currentLon : CLLocationDegrees = currentLocation.coordinate.latitude
                
                let request = MKDirectionsRequest()
                
                //starting point for routing directions - current location
                request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)))
                
                //ending point for routing directions - address string from the TableViewCells
                request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destLatitude,longitude: destLongitude)))
                
                request.requestsAlternateRoutes = false
                //request.transportType = .transit // only for ETA calculations - Estimated Time of Arrival
                
                //getting the route-based directions data from Apple servers using the MKDirections object - directions
                let directions = MKDirections(request: request)
                
                directions.calculate {[unowned self] response, error in
                    guard let unwrappedResponse = response else { return }
                    
                    //added and set the polyline on the map
                    for route in unwrappedResponse.routes {
                        self.mymapView.add(route.polyline)
                        self.mymapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
                    }
                }
            }
        }
    }
    
    //confirming the object of MKOverlay of class MKOverlayRenderer for visual representation of the polyline on map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //providing visual representation for the MKPolyline overlay object using MKPolylineRenderer class.
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.brown
        renderer.lineWidth = 2.0
        return renderer
    }
    
    let regionRadius: CLLocationDistance = 1000
    let annotation = MKPointAnnotation()
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2.0,
                                                                  regionRadius * 2.0)
        mymapView.setRegion(coordinateRegion, animated: true)
        mymapView.showsUserLocation = true
    }
    
    func isCoordinateValid(lat : CLLocationDegrees, lon : CLLocationDegrees) -> Bool
    {
        let mylocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lon)
        if(CLLocationCoordinate2DIsValid(mylocation)) {
            print("Valid")
            return true
        } else {
            print("InValid")
            return false
        }
    }
}
