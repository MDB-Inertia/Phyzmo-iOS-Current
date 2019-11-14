//
//  Video.swift
//  Phyzmo
//
//  Created by Anik Gupta on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Firebase
class Video{
    var id : String
    var thumbnail : UIImage
    var video : AVPlayer? // stays null until collection view is clicked
    var data : [String: Any]? // stays null until collection view is clicked or objects is set
    var objects_selected : [String] // The objects to be detected (will be read from firebase)
    var objects_detected : [String]? // The objects in the video

    
    init(id: String, thumbnail: UIImage, objects_selected: [String]) {
        self.id = id
        self.thumbnail = thumbnail
        self.objects_selected = objects_selected
    }
    
    func contruct(completion: @escaping () -> ()) {
        // Create a reference to the file you want to download
        let videoRef = Storage.storage().reference().child("\(id).mp4")
        videoRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
          } else {
            self.video = AVPlayer(url: url!)
            self.getData()
            
            APIClient.getExistingVidData(id: self.id, completion: { (objectsData) in
                print("keys\(objectsData.keys)")
                self.objects_detected = Array(objectsData.keys)
                completion()
            })
          }
        }
        
        
       
    }
    
    func getData(){
        APIClient.getObjectData(objectsDataUri: "https://storage.googleapis.com/phyzmo-videos/\(id).json", obj_descriptions: objects_selected) { (data) in
            self.data = data as! [String : Any]
        }
    }
    
    func deconstruct(){
        self.video = nil
        self.data = nil
        self.objects_detected = nil
    }
}
