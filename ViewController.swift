//
//  ViewController.swift
//  foodTracker
//
//  Created by Joey Lieb on 7/20/23.
//

import UIKit
import AVFoundation
import Photos

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    
    var newestFoodPicture:UIImage!
    var foodLocation:CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        picker.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func foodCamerAddButton(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            switch AVCaptureDevice.authorizationStatus(for: .video){
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
                    guard accessGranted == true else { return }
                    // handle denied access
                })
            case .authorized:
                break
            default:
                return
            }
            
            picker.sourceType = .camera
            picker.cameraDevice = .rear
            picker.allowsEditing = false
            picker.cameraCaptureMode = .photo
            present(picker, animated: true)
            
        } else {
            // handle no camera
        }
    }
    
    @IBAction func foodLibraryAddButton(_ sender: Any) {
        PHPhotoLibrary.requestAuthorization(for: .readWrite, handler: {(status) in
            DispatchQueue.main.async {
                self.handleLibraryButtonAuth(with: status)
            }
        })
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        newestFoodPicture = info[.originalImage] as? UIImage
        
        let asset = info[.phAsset] as? PHAsset
        
        if picker.sourceType != .camera {
            foodLocation = getPhotoLocation(with: asset!)
        }
        
        dismiss(animated: true)
        performSegue(withIdentifier: "foodPictureSubmitted", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "foodPictureSubmitted":
            let nextVC = segue.destination as? FoodSubmittedViewController
            guard newestFoodPicture != nil else {return}
            nextVC?.foodImage = newestFoodPicture
            nextVC?.foodLocation = foodLocation
        default:
            print("Segue happened and it was not handeled")
        }
        
    }
    
    func handleLibraryButtonAuth(with status:PHAuthorizationStatus){
        switch status {
        case .authorized:
            picker.sourceType = .photoLibrary
            present(picker, animated: true)
        case .notDetermined:
            return
        case .restricted:
            return
        case .denied:
            return
        case .limited:
            return
        @unknown default:
            return
        }
    }
    
    func getPhotoLocation(with asset:PHAsset) -> CLLocationCoordinate2D {
        if  let photoCoords = asset.location?.coordinate{
            return photoCoords
        }  else {
            let momentContainingAsset = PHAssetCollection.fetchAssetCollectionsContaining(asset, with: .moment, options: nil)
            for i in 0..<momentContainingAsset.count {
                let moment = momentContainingAsset.object(at: i)
                if let momentCoordinate = moment.approximateLocation?.coordinate {
                    return momentCoordinate
                }
            }
        }
        
        return CLLocationCoordinate2D(latitude: 0, longitude: 0)
    }
    
}
    

