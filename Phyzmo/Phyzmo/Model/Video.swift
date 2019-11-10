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
    var data : [String: [Double]]? // stays null until collection view is clicked
    var objects : [String]
    
    
    init(id: String, thumbnail: UIImage, objects: [String]) {
        self.id = id
        self.thumbnail = thumbnail
        self.objects = objects
    }
    
    func contruct(){
        // Create a reference to the file you want to download
        let videoRef = Storage.storage().reference().child("NEED TO GET FROM PATRICK")
        videoRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
          } else {
            self.video = AVPlayer(url: url!)
          }
        }

        APIClient.getObjectData(objectsDataUri: "NEEDTOFIND-ASK IMRAN FROM CLOUD FUNCTION", obj_descriptions: objects) { (data) in
            self.data = data as! [String : [Double]]
        }
    }
    
    func deconstruct(){
        self.video = nil
        self.data = nil
    }
}
