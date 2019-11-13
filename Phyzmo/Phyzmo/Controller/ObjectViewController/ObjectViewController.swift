//
//  ObjectViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import Firebase

class ObjectViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    //var video : Video? // MAY WANT TO CHANGE THIS SO THAT ONLY THE DATAVIEWCONTROLLER HAS VIDEO OBJECT
    override func viewDidLoad() {
        super.viewDidLoad()
        //let tabController = self.tabBarController as! DataViewController
        //self.video = tabController.video
        
        
        tableView.register(ObjectTableViewCell.self, forCellReuseIdentifier: "objectCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        //updateTable()
        tableView.reloadData()
    }
    
    @IBAction func objectSelectionPressed(_ sender: Any) {
        let videoReference = Database.database().reference().child("Videos")
        videoReference.setValue(["\((self.tabBarController as! DataViewController).video!.id)": (self.tabBarController as! DataViewController).video!.objects_selected])
        print((self.tabBarController as! DataViewController).video!.id)
        APIClient.getObjectData(objectsDataUri: "https://storage.googleapis.com/phyzmo-videos/\((self.tabBarController as! DataViewController).video!.id).json", obj_descriptions: (self.tabBarController as! DataViewController).video!.objects_selected) { (data) in
            
            //(self.tabBarController as! DataViewController).video!.data = data as? [String:Any]
            //print((self.tabBarController as! DataViewController).video!.data)
            DispatchQueue.main.async {
                (self.tabBarController as! DataViewController).video?.data = data as? [String : Any]
                for button in self.tabBarController!.tabBar.items!{
                    button.isEnabled = true
                }
            }
            
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    // TO ensure that check boxes are always on the right side of the screen
    
    override func viewWillTransition(to: CGSize, with: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: to, with: with)
        tableView.reloadData()
    }
}
