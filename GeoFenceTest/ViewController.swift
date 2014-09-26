//
//  ViewController.swift
//  GeoFenceTest
//
//  Created by Rich Fellure on 9/24/14.
//  Copyright (c) 2014 Mobile Makers. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController
{

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var checkInLabel: UILabel!
    @IBOutlet weak var regionSizeLabel: UILabel!

    let parseCoordinate = CLLocationCoordinate2DMake(41.893676, -87.635416)
    //TODO: get the googleMaps coordinates here
    let mapsCoordinate = CLLocationCoordinate2DMake(41.893676, -87.635416)
    let geofenceManager = GeofenceManager()
    let defaults = NSUserDefaults.standardUserDefaults()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        GeofenceManager.sharedInstance.locationManagerSetUp()

        NSNotificationCenter.defaultCenter().addObserverForName(kNSNotificationCenterInsideAlert, object: nil, queue: nil) { (notification) -> Void in

            self.checkInLabel.text = "Checked In!"
            self.checkInLabel.textColor = UIColor.greenColor()
        }

        NSNotificationCenter.defaultCenter().addObserverForName(kNSNotificationCenterOutsideAlert, object: nil, queue: nil) { (notification) -> Void in
            self.checkInLabel.textColor = UIColor.redColor()
            self.checkInLabel.text = "Checked Out!"
        }
    }

    @IBAction func onPressedChangeCoordinatesUsed(sender: UISegmentedControl)
    {

    }

    @IBAction func onPressedSwitchGPS(sender: UISegmentedControl)
    {

        if sender.selectedSegmentIndex == 0
        {
            GeofenceManager.sharedInstance.startUpdatingUsingGPS()
        }
        else
        {
            GeofenceManager.sharedInstance.startUpdatingUsingCell()
        }
    }

    @IBAction func onDragChangeRegionSize(sender: UISlider)
    {
        let double = Double(sender.value)

        GeofenceManager.sharedInstance.monitorThisRegion(parseCoordinate, identifier: "Region", regionRadius: double)

        regionSizeLabel.text = "\(double)"
    }
}

