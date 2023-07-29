//
//  FoodSubmittedViewController.swift
//  foodTracker
//
//  Created by Joey Lieb on 7/20/23.
//

import UIKit
import MapKit
import CoreLocation

class FoodSubmittedViewController: UIViewController, MKMapViewDelegate, TagsSubmit {
    
    
    
    @IBOutlet weak var foodImageDisplay: UIImageView!
    var defaults = UserDefaults.standard
    var foodImage:UIImage!
    var foodLocation:CLLocationCoordinate2D!
    var _tagList: Array<String> = []
    var tagList: Array<String> {
        get {
            return _tagList
        }
        set (newValue) {
            tagsOutput.text = "Tags: " + newValue.joined(separator: ", ")
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tagsOutput: UITextView!
    
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
        
        if (foodLocation.latitude == 0 && foodLocation.longitude == 0){
            mapView.isHidden = true
        }
        
        
        
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
    
    func submittedData(selectedTags: Array<String>) {
        print("Fired Event")
        tagsOutput.text = "Tags: " + selectedTags.joined(separator: ", ")
    }
    
}
