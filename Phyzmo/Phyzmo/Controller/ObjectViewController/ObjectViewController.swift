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
    let canvas = Canvas()
    var imageView: UIImageView!
    var imageWidth : CGFloat?
    var imageHeight : CGFloat?
    
    @IBOutlet weak var segmented: UISegmentedControl!
    
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
    
        view.addSubview(canvas)
        canvas.backgroundColor = UIColor(white: 1, alpha: 0.1)
        canvas.frame = view.frame
        
        let image = (self.tabBarController as! DataViewController).video!.thumbnail
        imageView = UIImageView(image: image)
        //Format ImageView
//        imageView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.contentSize.width, height: tableView.contentSize.height)
//        let midX = self.view.bounds.midX
//        let midY = self.view.bounds.midY
//        let size: CGFloat = 64
//        imageView.frame = CGRect(x: view.bounds.width/2, y: view.bounds.height/2, width: 500, height: 500)
        
//        imageWidth = 15*view.frame.width/16
//        imageHeight = 10*view.frame.height/16
        imageWidth = image.size.width
        imageHeight = image.size.height
        imageView.frame = CGRect(x: view.frame.width/2-imageWidth!/2, y: view.frame.height/2-imageHeight!/2, width: imageWidth!, height: imageHeight!)
        view.addSubview(imageView)
        canvas.tag = 100
        imageView.tag = 101
        canvas.frame = imageView.frame
//        canvas.frame = CGRect(x: view.frame.width/2-imageWidth!/2, y: view.frame.height/2-imageHeight!/2, width: imageView.image!.size.width, height: imageView.image!.size.height)
        imageView.backgroundColor = UIColor.purple.withAlphaComponent(0.3)
        
        
        
        //Imageview on Top of View
        self.view.bringSubviewToFront(canvas)
        print("view success")
        
        view.viewWithTag(100)!.isHidden = true
        view.viewWithTag(101)!.isHidden = true
    }
    
    @IBAction func segmented(_ sender: Any) {
        switch segmented.selectedSegmentIndex
        {
        case 0:
            view.viewWithTag(100)!.isHidden = true
            view.viewWithTag(101)!.isHidden = true
            tableView.isHidden = false
        case 1:
            view.viewWithTag(100)!.isHidden = false
            view.viewWithTag(101)!.isHidden = false
            tableView.isHidden = true
        default:
            break
        }
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
        imageWidth = 15*to.width/16
        imageHeight = 10*to.height/16
        imageView.frame = CGRect(x: to.width/2-imageWidth!/2, y: to.height/2-imageHeight!/2, width: imageWidth!, height: imageHeight!)
        imageView.contentMode = .scaleAspectFit
        //canvas.frame = imageView.frame
        canvas.frame = CGRect(x: to.width/2-imageWidth!/2, y: to.height/2-imageHeight!/2, width: imageView.image!.size.width, height: imageView.image!.size.height)
    }
}
