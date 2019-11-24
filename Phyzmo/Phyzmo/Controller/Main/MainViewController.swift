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
    @IBOutlet weak var trashButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var logOutButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var welcomeLabel: GradientLabel!
    
    let reuseIdentifier = "GalleryCell"
    let sectionInsets = UIEdgeInsets(top: 10.0,
    left: 10.0,
    bottom: 50.0,
    right:10.0)
    var itemsPerRow: CGFloat = 3
    var videos: [Video] = []
    var videoId : String?
    var video: Video?
    var videosSelected: [String] = []
    var group = DispatchGroup()
    //var updateGroup = DispatchGroup()
    var shouldSegue = false
    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            //view.backgroundColor = .clear

            
            //always fill the view
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            view.bringSubviewToFront(statusLabel)
            view.bringSubviewToFront(loading)
             //if you have more UIViews, use an insertSubview API to place it where needed
        }
        
        selectButton.setTitle("Cancel", for: .selected)
        selectButton.backgroundColor = .clear
        selectButton.setTitle("Select", for: .normal)
        trashButton.addConstraint(trashButton.heightAnchor.constraint(equalToConstant: 0))
        
        blurEffectView.isHidden = false
        loading.isHidden = false
        loading.startAnimating()
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        statusLabel.isHidden = false
        statusLabel.text = "Loading your datasets!"
        let currentUserId = Auth.auth().currentUser!.uid
        let databaseReference = Database.database().reference().child("Users").child(currentUserId)
        databaseReference.child("fullname").observeSingleEvent(of: .value, with: { (snapshot) in
            print("key", snapshot.key)
            print("value", snapshot.value)
            if snapshot.value is AnyObject {
                let name = snapshot.value as! String
                self.welcomeLabel.text = "Welcome, \(name.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)[0])"
                self.welcomeLabel.gradientColors = [UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor,
                                                    //UIColor(red:0.84, green:0.07, blue:0.72, alpha:1.0).cgColor,
                    //UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor,
                    UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor, UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor]
            } else {
                self.welcomeLabel.text = "Welcome"
                self.welcomeLabel.gradientColors = [UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor, UIColor(red:0.84, green:0.07, blue:0.72, alpha:1.0).cgColor,UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor,UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor, UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor]
            }
          }) { (error) in
            print(error.localizedDescription)
            self.welcomeLabel.text = "Welcome"
        }
        
        databaseReference.observe(.value) { (snapshot) in
            self.updateCollection()
        }
        
        //self.navigationController?.navigationBar.backgroundColor = UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0)
        
        self.navigationController?.navigationBar.setGradientBackground(colors: [
        UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor,
        UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor,
        UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor
        //UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor
        ])

        
    }
    func updateCollection(){
       // self.updateGroup.enter()
//        statusLabel.isHidden = false
//        statusLabel.text = "Loading your datasets!"
        print("update Collection")
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
                self.group = DispatchGroup()
                for (index,vidId) in videoIds.reversed().enumerated() {
                    self.group.enter()
                    storageReference.child("\(vidId).jpg").getData(maxSize: 1 * 1024 * 1024) { data, error in
                      if let error = error {
                        // Uh-oh, an error occurred!
                        print("\(vidId).jpg not found")
                      } else {
                        let image = UIImage(data: data!)
                        /*let ref = Database.database().reference().child("Videos").child(vidId).child("objects_selected")
                        self.group.enter()
                        ref.observeSingleEvent(of: .value) { (snapshot) in
                            if snapshot.value is [AnyObject] {
                                let objects_selected = snapshot.value as! [String]
                                print(objects_selected)
                                self.videos.append(Video(id: vidId, thumbnail: image!, objects_selected: objects_selected))
                            }
                            else{
                                self.videos.append(Video(id: vidId, thumbnail: image!, objects_selected: []))
                            }
                            self.group.leave()
                            
                        }*/
                        self.videos.append(Video(id: vidId, thumbnail: image!))
                        print("\(vidId).jpg found")
                      }
                        self.group.leave()
                    }
                }
                self.group.notify(queue: DispatchQueue.main) {
                    // ALL VIDEOS ARE LOADED AS INTO ARRAY
                    print("group notify")
                    self.videos.sort { (a, b) -> Bool in
                        for i in 0...videoIds.reversed().count {
                            if a.id == videoIds.reversed()[i] {
                                return true
                            }
                            else if b.id == videoIds.reversed()[i] {
                                return false
                            }
                        }
                        return false
                    }
                    
                    //DispatchQueue.main.async{
                        print("update text notify")
                        self.loading.isHidden = true
                        self.loading.stopAnimating()
                        print(self.videos.count)
                        if self.videos.count == 0 {
                            self.statusLabel.isHidden = false
                            self.statusLabel.text = "You have no datasets\nClick the camera above to begin!"
                        }
                        else{
                            self.statusLabel.isHidden = true
                        }
                        
                        print("reloaded")
                        /*self.logOutButton.isEnabled = true
                        self.selectButton.isEnabled = true
                        self.collectionView.isUserInteractionEnabled = true
                        self.cameraButton.isEnabled = true*/
                    //}
                    print("reload data")
                    self.collectionView.reloadData()
                    self.loading.isHidden = true
                    self.loading.stopAnimating()
                    self.blurEffectView.isHidden = true
                    /*self.logOutButton.isEnabled = true
                    self.selectButton.isEnabled = true
                    self.collectionView.isUserInteractionEnabled = true
                    self.cameraButton.isEnabled = true*/
                    self.toggleEnableAll(true)
                    //self.updateGroup.leave()
                    if self.shouldSegue {
                        self.shouldSegue = false
                        self.video = self.videos[0]
                        self.loading.isHidden = false
                        self.loading.startAnimating()
                        self.blurEffectView.isHidden = false
                        self.video?.construct(completion: {
                            
                            DispatchQueue.main.async {
                                self.loading.isHidden = true
                                self.loading.stopAnimating()
                                self.blurEffectView.isHidden = true
                                self.performSegue(withIdentifier: "MainToVideo", sender: self)
                            }
                        })
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

    @IBAction func deletePressed(_ sender: Any) {
        
        //TODO - delete all references in Firebase, GCP, etc. with the id's in videosSelected
        let ref = Database.database().reference()
        let storageRef = Storage.storage().reference()
        let gcpRef = Storage.storage(url:"gs://phyzmo-videos").reference()

        ref.child("Users").child(Auth.auth().currentUser!.uid).child("videoId").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.value is [AnyObject] {
                var arr = snapshot.value as! [String]
                arr.removeAll { (s) -> Bool in
                    return self.videosSelected.contains(s)
                }
                print(arr)
                print(self.videosSelected)
                ref.child("Users").child(Auth.auth().currentUser!.uid).updateChildValues(["videoId": arr])

            }
            
            for id in self.videosSelected {
                //DELETE FROM DATABASE
                
                ref.child("Videos").child(id).setValue([])
                // Create a reference to the file to delete
               
                
                // Delete the file
                storageRef.child("\(id).mp4").delete { error in
                  if let error = error {
                    // Uh-oh, an error occurred!
                  } else {
                    // File deleted successfully
                  }
                }
                
                storageRef.child("\(id).jpg").delete { error in
                  if let error = error {
                    // Uh-oh, an error occurred!
                    print(error)
                  } else {
                    // File deleted successfully
                  }
                }
                
                
                print(gcpRef.child("\(id).json"))
                gcpRef.child("\(id).json").delete { (error) in
                    if let error = error {
                      // Uh-oh, an error occurred!
                      print(error)
                    } else {
                      // File deleted successfully
                    }
                }
                

                //Database.database().reference().child("Users").child(Auth.auth().currentUser!.uid).child("videoId").child(id).removeValue()
            }
            self.selectPressed(self)
            
        })
        
        
        //updateCollection()
        
    }
    @IBAction func logOutButtonPressed(_ sender: Any) {
        try! Auth.auth().signOut()
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func selectPressed(_ sender: Any) {
        selectButton.isSelected = !selectButton.isSelected
        
        if videosSelected.count == 0 {
            trashButton.isEnabled = false
        }
        else{
            trashButton.isEnabled = true
        }
        
        print(selectButton.isSelected)
        if selectButton.isSelected {
            
            for cell in collectionView.visibleCells {
                (cell as! GalleryCollectionViewCell).checkMark.style = .openCircle
            }
            trashButton.isHidden = false
            for c in trashButton.constraints {
                print(c)
                if c.constant == 0{
                    trashButton.removeConstraint(c)
                }
            }
            trashButton.addConstraint(trashButton.heightAnchor.constraint(equalToConstant: 50))
        }
        else{
            videosSelected.removeAll()
            for cell in collectionView.visibleCells {
                (cell as! GalleryCollectionViewCell).checkMark.style = .nothing
                (cell as! GalleryCollectionViewCell).checkMark.checked = false
                (cell as! GalleryCollectionViewCell).imageTint.isHidden = true
            }
            for c in trashButton.constraints {
               if c.constant == 50{
                   trashButton.removeConstraint(c)
               }
            }
            trashButton.addConstraint(trashButton.heightAnchor.constraint(equalToConstant: 0))
            
            
            
        }
    }
    @IBAction func cameraButtonPressed(_ sender: Any) {
        print("working")
        VideoHelper.startMediaBrowser(delegate: self, sourceType: .camera)

    }
    
    override func viewWillTransition(to: CGSize, with: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: to, with: with)
        collectionView.reloadData()
        /*self.welcomeLabel.gradientColors = [UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor,
                                        //UIColor(red:0.84, green:0.07, blue:0.72, alpha:1.0).cgColor,
        //UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor,
        UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor, UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor]*/
        
        
    }
    
    func toggleEnableAll(_ isEnabled: Bool){
        self.logOutButton.isEnabled = isEnabled
        self.selectButton.isEnabled = isEnabled
        self.collectionView.isUserInteractionEnabled = isEnabled
        self.cameraButton.isEnabled = isEnabled
    }
    
}

