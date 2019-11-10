//
//  RecordVideoViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import MobileCoreServices
import Firebase
import AVKit
import AVFoundation
import Firebase

extension MainViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String,
          mediaType == (kUTTypeMovie as String),
            let url = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
          UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path)
          else {
            return
        }
        
        // Handle a movie capture
        print("url.path", url.path)
        print("info", info)
        UISaveVideoAtPathToSavedPhotosAlbum(
          url.path,
          self,
          #selector(video(_:didFinishSavingWithError:contextInfo:)),
          nil)
        uploadToFirebase(url: url)
        
    }
    
    func uploadToFirebase(url: URL) {
        let currentUserId = Auth.auth().currentUser!.uid
        print("currentUserId", currentUserId)
        let databaseReference = Database.database().reference().child("Users").child(currentUserId)
        print("databaseReference", databaseReference)
        let videoId = databaseReference.childByAutoId().key
        print("videoId", videoId)
        let storageReference = Storage.storage().reference().child("videos/\(videoId)")

        // Start the video storage process
        storageReference.putFile(from: url as URL, metadata: nil, completion: { (metadata, error) in
            if error == nil {
                print("Successful video upload")
                
                databaseReference.child("videoId").observeSingleEvent(of: .value, with: { (snapshot) in
                    print("key", snapshot.key)
                    print("value", snapshot.value)
                    if snapshot.value is [AnyObject] {
                        print("not nil", snapshot.value)
                        databaseReference.updateChildValues(["videoId":(snapshot.value as! [String]) + [videoId!]])
                    } else {
                        print("nil")
                        databaseReference.updateChildValues(["videoId":[videoId!]])
                    }
                  }) { (error) in
                    print(error.localizedDescription)
                }
            } else {
                print(error?.localizedDescription)
            }
        })
    }
    
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
      let title = (error == nil) ? "Success" : "Error"
      let message = (error == nil) ? "Video was saved" : "Video failed to save"
      
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
      present(alert, animated: true, completion: nil)
    }
}

extension MainViewController: UINavigationControllerDelegate {
}

