//
//  MainViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import Firebase
import CheckMarkView
class MainViewController: UIViewController {
    
    //UIElements
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var chartButton: UIButton!
    
    let reuseIdentifier = "GalleryCell"
    let sectionInsets = UIEdgeInsets(top: 10.0,
    left: 10.0,
    bottom: 50.0,
    right:10.0)
    let itemsPerRow: CGFloat = 3
    
    
    var videos: [Video] = []
    var videoId : String?
    var video: Video?
    override func viewDidLoad() {
        super.viewDidLoad()
        loading.isHidden = true
        //loading.startAnimating()
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        statusLabel.isHidden = true
        statusLabel.text = "Loading your datasets!"
        let currentUserId = Auth.auth().currentUser!.uid
        let databaseReference = Database.database().reference().child("Users").child(currentUserId)
        databaseReference.child("fullname").observeSingleEvent(of: .value, with: { (snapshot) in
            print("key", snapshot.key)
            print("value", snapshot.value)
            if snapshot.value is AnyObject {
                let name = snapshot.value as! String
                self.welcomeLabel.text = "Welcome, \(name.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)[0])"
            } else {
                self.welcomeLabel.text = "Welcome"
                //print(snapshot.value)
            }
          }) { (error) in
            print(error.localizedDescription)
            self.welcomeLabel.text = "Welcome"
        }
        //tableView.rowHeight = 60
        updateCollection()
        collectionView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    func updateCollection(){
        videos.removeAll()
        
        let currentUserId = Auth.auth().currentUser!.uid
        print("currentUserId", currentUserId)
        let databaseReference = Database.database().reference().child("Users").child(currentUserId)
        let storageReference = Storage.storage().reference()
        databaseReference.child("videoId").observeSingleEvent(of: .value, with: { (snapshot) in
            print("key", snapshot.key)
            print("value", snapshot.value)
            if snapshot.value is [AnyObject] {
                let videoIds = snapshot.value as! [String]
                print(videoIds)
                
                /* MUST FIND A WAY TO ENSURE THAT THESE VIDEOS ARE ADDED TO THE ARRAY IN THE ORDER
                  BECAUSE THESE SYNCHRONOUS CALLS SOMEWHAT JUMBLE THE ORDER AND USERS WANT THE MOST
                    RECENT DATA ON THE TOP */
                
                /*Also must find a way to say when all thumbnails are loaded*/
                
                for vidId in videoIds.reversed() {
                    storageReference.child("\(vidId).jpg").getData(maxSize: 1 * 1024 * 1024) { data, error in
                      if let error = error {
                        // Uh-oh, an error occurred!
                        print("\(vidId).jpg not found")
                      } else {
                        // Data for "images/island.jpg" is returned
                        let image = UIImage(data: data!)
                        let ref = Database.database().reference().child("Videos").child(vidId).child("objects_selected")
                        ref.observeSingleEvent(of: .value) { (snapshot) in
                            if snapshot.value is [AnyObject] {
                                let objects_selected = snapshot.value as! [String]
                                print(objects_selected)
                                self.videos.append(Video(id: vidId, thumbnail: image!, objects_selected: objects_selected))
                            }
                            else{
                                self.videos.append(Video(id: vidId, thumbnail: image!, objects_selected: []))
                            }
                            self.collectionView.reloadData()
                        }
                        
                        
                        //self.thumbnails.append(image!)
                        
                        print("\(vidId).jpg found")
                      }
                    }
                }
                    
                
            } else {
                //print(snapshot.value)
            }
          }) { (error) in
            print(error.localizedDescription)
        }
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    @IBAction func logOutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        print("working")
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)

    }
    
    /*@IBAction func chartButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "MainToVideo", sender: self)
    }*/
    override func viewWillTransition(to: CGSize, with: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: to, with: with)
        collectionView.reloadData()
    }
    
    
    
}
