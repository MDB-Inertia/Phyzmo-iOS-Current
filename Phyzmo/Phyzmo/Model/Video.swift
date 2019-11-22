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
    var line : [CGPoint]?
    var unit : Float?
    
    init(id: String, thumbnail: UIImage){//}, objects_selected: [String]) {
        self.id = id
        self.thumbnail = thumbnail
        self.objects_selected = []
        self.line = nil
        self.unit = nil
    }
    
    func construct(completion: @escaping () -> ()) {
        // Create a reference to the file you want to download
        let videoRef = Storage.storage().reference().child("\(id).mp4")
        videoRef.downloadURL { url, error in
          if let error = error {
            // Handle any errors
          } else {
            self.video = AVPlayer(url: url!)
            
            let ref = Database.database().reference().child("Videos").child(self.id).child("objects_selected")
            ref.observeSingleEvent(of: .value) { (snapshot) in
                if snapshot.value is [AnyObject] {
                    let objects_selected = snapshot.value as! [String]
                    self.objects_selected = objects_selected
                }
                else{
                    self.objects_selected = []
                }
                print("2")
                APIClient.getObjectData(objectsDataUri: "https://storage.googleapis.com/phyzmo-videos/\(self.id).json", obj_descriptions: self.objects_selected ?? [], line: self.line ?? [CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 0)], unit: self.unit ?? 1, max_coor: [CGFloat(5), CGFloat(5)]) { (data) in
                    self.data = data as! [String : Any]
                    APIClient.getExistingVidData(id: self.id, completion: { (objectsData) in
                        print("keys\(objectsData.keys)")
                        self.objects_detected = Array(objectsData.keys)
                        completion()
                    })
                }
                
            }
            
            
          }
        }
        
        
       
    }
    
    func getData(){
        
    }
    
    func deconstruct(){
        self.video = nil
        self.data = nil
        self.objects_detected = nil
        
    }
}
