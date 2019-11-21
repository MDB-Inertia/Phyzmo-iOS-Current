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
    
    @IBOutlet weak var selectButton: UIButton!
    var selectedObjects: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let tabController = self.tabBarController as! DataViewController
        //self.video = tabController.video
        
        tableView.register(ObjectTableViewCell.self, forCellReuseIdentifier: "objectCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        //updateTable()
        load()
        
    }
    func load(){
        selectedObjects = (self.tabBarController as! DataViewController).video!.objects_selected
        if (self.tabBarController as! DataViewController).video!.objects_selected == []{
            selectButton.isHighlighted = true
            selectButton.isEnabled = false
            
            
        }
        if selectedObjects == []{
            (self.tabBarController as! DataViewController).disableAllButObjects()
        }
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController!.navigationItem.rightBarButtonItem = nil
        load()
    }
    
    @IBAction func objectSelectionPressed(_ sender: Any) {
        /*if (self.tabBarController as! DataViewController).video!.objects_selected == []{
            let title = "Error"
            let message = "Please select at least one object"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }*/
        print("updating object selection")
        selectedObjects = (self.tabBarController as! DataViewController).video!.objects_selected
        let videoReference = Database.database().reference().child("Videos").child("\((self.tabBarController as! DataViewController).video!.id)")
        videoReference.setValue(["objects_selected": (self.tabBarController as! DataViewController).video!.objects_selected])
        print((self.tabBarController as! DataViewController).video!.id)
        APIClient.getObjectData(objectsDataUri: "https://storage.googleapis.com/phyzmo-videos/\((self.tabBarController as! DataViewController).video!.id).json", obj_descriptions: (self.tabBarController as! DataViewController).video!.objects_selected) { (data) in
            
            //(self.tabBarController as! DataViewController).video!.data = data as? [String:Any]
            //print((self.tabBarController as! DataViewController).video!.data)
            DispatchQueue.main.async {
                (self.tabBarController as! DataViewController).video?.data = data as? [String : Any]
                (self.tabBarController as! DataViewController).enableAll()
                (self.tabBarController as! DataViewController).selectedIndex = 1
            }
            
            
        }
    }
    /*override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        
    }
    
    override var shouldAutorotate: Bool {
        return false
        
    }*/
    
    // TO ensure that check boxes are always on the right side of the screen
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (self.tabBarController as! DataViewController).video!.objects_selected = selectedObjects!
    }
    override func viewWillTransition(to: CGSize, with: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: to, with: with)
        if tableView != nil {
            tableView.reloadData()
        }
    }
}
