//
//  ImageUtils.swift
//  foodTracker
//
//  Created by Joey Lieb on 7/29/23.
//

import Foundation
import UIKit

public class ImageUtils {
    func saveImage(imageName fileName:String, image: UIImage){
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else {return}
        
        if FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("Error removing old image ", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("Error saving image", error)
        }
    }
    
    func loadImageFromDisk(fileName: String) -> UIImage? {
        let documentsDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentsDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageURL.path)
            return image
        }
        
        return nil
    }
}
