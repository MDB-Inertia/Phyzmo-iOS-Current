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
    
    /*func updateTable(){
        events.removeAll()
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let ref = Database.database().reference()
        let eventRef = ref.child("events")
        eventRef.observe(DataEventType.value, with: { (snapshot) in
          let eventDict = snapshot.value as? [String : AnyObject] ?? [:]
            self.events.removeAll()
            let group = DispatchGroup()
            // Try using a Dispatch Queue --> .sync
            for id in eventDict.keys {
                //group.enter()
                ref.child("users").child(eventDict[id]!["creator"]!! as! String).observeSingleEvent(of: .value) { (snapshot) in
                    let user = snapshot.value as? [String : AnyObject] ?? [:]
                    let creator = user["name"]
                    let date = Date(timeIntervalSince1970: TimeInterval((eventDict[id]!["date"]!! as! Double)))
                    let description = eventDict[id]!["description"]!!
                    let title = eventDict[id]!["title"]!!
                    var interested = eventDict[id]!["interested"]!
                    if interested == nil {
                        interested = []
                    }
                    else {
                        interested = interested!
                    }
                    
                    let storage = Storage.storage().reference()
                    storage.child("images").child(id).getData(maxSize: 1 * 1024 * 1024){ (data, error) in
                        if data == nil {
                            return
                        }
                        guard let image = UIImage(data: data!) else {
                            return
                        }
                        print("Appending")
                        self.events.append(Event(title: title as! String, description: description as! String, image: image, date: date, creator: creator as! String, interested: interested as! [String], id: id))
                        //group.leave()
                        self.events.sort { (a, b) -> Bool in
                            a.date > b.date
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            
            
            /*group.notify(queue: DispatchQueue.main, execute: {
                print(self.events)
                self.events.sort { (a, b) -> Bool in
                    a.date > b.date
                }
                self.tableView.reloadData()
            })*/
        })
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    

}
