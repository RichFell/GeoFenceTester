//
//  GeofenceManager.swift
//  GeoFenceTest
//
//  Created by Rich Fellure on 9/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import Foundation
import CoreLocation

let kNSNotificationCenterInsideAlert = "kNSNotificationCenterInsideAlert"
let kNSNotificationCenterOutsideAlert = "kNSNotificationCenterOutsideAlert"

private let SharedGeoManager = GeofenceManager()

class GeofenceManager: NSObject, CLLocationManagerDelegate
{
    let locationManager = CLLocationManager()
    var location = CLLocation()
    var coordinate : CLLocationCoordinate2D = CLLocationCoordinate2DMake(41.893676, -87.635416)
    var radiusOfRegion = 1.0 as Double
    let defaults = NSUserDefaults.standardUserDefaults()
    let isInsideRegion = "isInsideRegion"


    class var sharedInstance: GeofenceManager
    {
        return SharedGeoManager
    }

    override init()
    {
        super.init()

        locationManagerSetUp()
    }

    func locationManagerSetUp()
    {
        //Requires NSLocationAlwaysUsageDescription key and value in Info.plist
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        if defaults.valueForKey(isInsideRegion) == nil
        {
            defaults.setBool(false, forKey: isInsideRegion)
            defaults.synchronize()
        }
    }

    func startUpdatingUsingGPS()
    {
        locationManager.startUpdatingLocation()
        locationManager.stopMonitoringSignificantLocationChanges()
    }

    func startUpdatingUsingCell()
    {
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
    }

    func monitorThisRegion(location : CLLocationCoordinate2D, identifier : String, regionRadius: Double) {
        let passedLocation = location

        radiusOfRegion = regionRadius
        //These methods create the "Geofence", and trigger the delegate methods

         locationManager.startMonitoringForRegion(CLCircularRegion(circularRegionWithCenter: passedLocation, radius: regionRadius, identifier: identifier))

        locationManager.requestStateForRegion(CLCircularRegion(circularRegionWithCenter: passedLocation, radius: regionRadius, identifier: identifier))
        //        println("request state for region")
    }


    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!)
    {

        let officeLocation = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        let distanceFromOffice = newLocation.distanceFromLocation(officeLocation) as Double
//
        if defaults.valueForKey(isInsideRegion).boolValue == false
        {
            if distanceFromOffice < radiusOfRegion
            {

                NSNotificationCenter.defaultCenter().postNotificationName(kNSNotificationCenterInsideAlert, object: self)

                defaults.setBool(true, forKey: isInsideRegion)
                defaults.synchronize()

            }
        }
        else
        {
            if distanceFromOffice > radiusOfRegion
            {
                NSNotificationCenter.defaultCenter().postNotificationName(kNSNotificationCenterOutsideAlert, object: nil)

                defaults.setBool(false, forKey: isInsideRegion)
                defaults.synchronize()
            }
        }
    }

    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!)
    {
        if defaults.valueForKey(isInsideRegion).boolValue == false
        {
            NSNotificationCenter.defaultCenter().postNotificationName(kNSNotificationCenterInsideAlert, object: nil)
            defaults.setBool(true, forKey: isInsideRegion)
            defaults.synchronize()
        }
    }

    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!)
    {
        if defaults.valueForKey(isInsideRegion).boolValue == true
        {
            NSNotificationCenter.defaultCenter().postNotificationName(kNSNotificationCenterOutsideAlert, object: nil)
            defaults.setBool(false, forKey: isInsideRegion)
            defaults.synchronize()
        }
    }


    func changeGeopoint(theCoordinate: CLLocationCoordinate2D)
    {
        coordinate = theCoordinate
    }
}