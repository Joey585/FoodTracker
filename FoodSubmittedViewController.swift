//
//  FoodSubmittedViewController.swift
//  foodTracker
//
//  Created by Joey Lieb on 7/20/23.
//

import UIKit
import MapKit
import CoreLocation

class FoodSubmittedViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var foodImageDisplay: UIImageView!
    var foodImage:UIImage!
    var foodLocation:CLLocationCoordinate2D!
    
    @IBOutlet weak var mapView: MKMapView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
                        
        foodImageDisplay.image = foodImage
        foodImageDisplay.contentMode = .scaleAspectFit
        
        mapView.showsUserLocation = true
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.isPitchEnabled = false 
        
        
        // Do any additional setup after loading the view.
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        
        var region:MKCoordinateRegion!
        
        if foodLocation != nil {
            let annotation = MKPointAnnotation()
            annotation.coordinate = foodLocation
            annotation.title = "Your Food Image"
            
            mapView.showsUserLocation = false
            mapView.addAnnotation(annotation)
            region = MKCoordinateRegion(center: foodLocation, latitudinalMeters: 200, longitudinalMeters: 100)
        } else {
            let userLocation = mapView.userLocation
            region = MKCoordinateRegion(center: userLocation.location!.coordinate, latitudinalMeters: 200, longitudinalMeters: 100)
        }
        
        mapView.setRegion(region, animated: true)
    }

}
