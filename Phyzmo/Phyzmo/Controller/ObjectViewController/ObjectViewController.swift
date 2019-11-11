//
//  ObjectViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit

class ObjectViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var video : Video?
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabController = self.tabBarController as! DataViewController
        self.video = tabController.video
        
        
        tableView.register(ObjectTableViewCell.self, forCellReuseIdentifier: "objectCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        //updateTable()
        tableView.reloadData()
    }
    
    @IBAction func objectSelectionPressed(_ sender: Any) {
        print(video!.id)
        APIClient.getObjectData(objectsDataUri: "https://storage.googleapis.com/phyzmo-videos/\(video!.id).json", obj_descriptions: video!.objects_selected) { (data) in
            
            self.video!.data = data as? [String:Any]
            print(self.video!.data)
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
