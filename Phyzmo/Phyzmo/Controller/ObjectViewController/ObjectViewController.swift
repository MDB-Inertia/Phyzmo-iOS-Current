//
//  ObjectViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import Firebase
import SkyFloatingLabelTextField

class ObjectViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var selectButton: UIButton!
    var selectedObjects: [String]?
    
    var gradient = [UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor, UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor]
    let canvas = Canvas()
    var imageView: UIImageView!
    var imageWidth : CGFloat?
    var imageHeight : CGFloat?
    var keyboardAdjusted = false
    var lastKeyboardOffset: CGFloat = 0.0
    @IBOutlet weak var distanceTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var segmented: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Render Select Button
        self.selectButton.applyGradient(colors: gradient)
        
        // Render Table View
        tableView.register(ObjectTableViewCell.self, forCellReuseIdentifier: "objectCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        load()
        let image = (self.tabBarController as! DataViewController).video!.thumbnail
        imageView = UIImageView(image: image)
        imageWidth = image.size.width
        imageHeight = image.size.height
        let proportion = Float(imageWidth!)/Float(imageHeight!)
        var width = Float(view.frame.height - 275)*proportion
        var height = width/proportion
        if width > Float(view.frame.width) {
            height = Float(view.frame.width)/proportion
            width = height*proportion
        }
        
        imageView.frame = CGRect(x: view.frame.width/2-CGFloat(width)/2, y: view.frame.height/2-CGFloat(height)/2, width: CGFloat(width), height: CGFloat(height))
        canvas.frame = imageView.frame
        view.addSubview(imageView)
        canvas.tag = 100
        imageView.tag = 101
        canvas.frame = imageView.frame
        canvas.backgroundColor = UIColor(white: 1, alpha: 0.1)
        self.distanceTextField.keyboardType = UIKeyboardType.decimalPad
        if (self.tabBarController as! DataViewController).video!.line != nil{
            let line = (self.tabBarController as! DataViewController).video!.line!
            canvas.line = [CGPoint(x: Double(line[0].x)*Double(width), y: Double(line[0].y)*Double(height)), CGPoint(x: Double(line[1].x)*Double(width), y: Double(line[1].y)*Double(height))]
            
        }
        if (self.tabBarController as! DataViewController).video!.unit != nil{
            distanceTextField.text = ("\((self.tabBarController as! DataViewController).video!.unit!)")
        }
        
        view.addSubview(canvas)

        
        //Imageview on Top of View
        self.view.bringSubviewToFront(canvas)
        print("view success")
        
        toggleObjects()
    }
    
    @IBAction func editChanged(_ sender: Any) {
        updateSelectButton()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func updateSelectButton() {
        if (self.tabBarController as! DataViewController).video!.objects_selected == [] || distanceTextField.text == "" || canvas.getArray().count < 2 {
            selectButton.isEnabled = false
            gradient = [UIColor(red:0.01, green:0.51, blue:0.93, alpha:0.5).cgColor, UIColor(red:0.55, green:0.27, blue:0.92, alpha:0.5).cgColor]
            selectButton.applyGradient(colors: gradient)
        }
        else{
            selectButton.isEnabled = true
            gradient = [UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0).cgColor, UIColor(red:0.55, green:0.27, blue:0.92, alpha:1.0).cgColor]
            selectButton.applyGradient(colors: gradient)
        }
        if selectedObjects == [] ||
            (self.tabBarController as! DataViewController).video!.line == nil ||
            (self.tabBarController as! DataViewController).video!.line == [] ||
            (self.tabBarController as! DataViewController).video!.unit == nil {
            (self.tabBarController as! DataViewController).disableAllButObjects()
        }
        print("line", canvas.getArray())
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        updateSelectButton()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        updateSelectButton()
    }
    
    @IBAction func segmented(_ sender: Any) {
        segment()
    }
    
    func segment(){
        switch segmented.selectedSegmentIndex
        {
        case 0:
            toggleObjects()
        case 1:
            toggleDistance()
        default:
            break
        }
    }
    func load(){
        selectedObjects = (self.tabBarController as! DataViewController).video!.objects_selected
        if (self.tabBarController as! DataViewController).video!.line != nil && imageView != nil{
            let line = (self.tabBarController as! DataViewController).video!.line!
            canvas.line = [CGPoint(x: Double(line[0].x)*Double(imageView.frame.width), y: Double(line[0].y)*Double(imageView.frame.height)), CGPoint(x: Double(line[1].x)*Double(imageView.frame.width), y: Double(line[1].y)*Double(imageView.frame.height))]
            canvas.setNeedsDisplay()
            
        }
        if (self.tabBarController as! DataViewController).video!.unit != nil{
            distanceTextField.text = ("\((self.tabBarController as! DataViewController).video!.unit!)")
        }
        
        updateSelectButton()
        tableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController!.navigationItem.rightBarButtonItem = nil
        load()
        segmented(self)
    }
    
    @IBAction func objectSelectionPressed(_ sender: Any) {
        
        print("updating object selection")
        let line = canvas.getArray()
        selectedObjects = (self.tabBarController as! DataViewController).video!.objects_selected
        (self.tabBarController as! DataViewController).video!.line = [CGPoint(x: line[0].x/imageView.frame.width, y: line[0].y/imageView.frame.height), CGPoint(x: line[1].x/imageView.frame.width, y: line[1].y/imageView.frame.height)]
        
        (self.tabBarController as! DataViewController).video!.unit = Float(distanceTextField.text!)
        let videoReference = Database.database().reference().child("Videos").child("\((self.tabBarController as! DataViewController).video!.id)")
        videoReference.setValue(["objects_selected": (self.tabBarController as! DataViewController).video!.objects_selected])
        print((self.tabBarController as! DataViewController).video!.id)
        print("line input", canvas.getArray())
        print("unit input", Float(distanceTextField.text!)!)
        
        
        videoReference.updateChildValues(["line": [[line[0].x/imageView.frame.width, line[0].y/imageView.frame.height], [line[1].x/imageView.frame.width, line[1].y/imageView.frame.height]]])
        videoReference.updateChildValues(["unit": Float(distanceTextField.text!)!])
        
        APIClient.getObjectData(objectsDataUri: "https://storage.googleapis.com/phyzmo-videos/\((self.tabBarController as! DataViewController).video!.id).json", obj_descriptions: (self.tabBarController as! DataViewController).video!.objects_selected, line: [CGPoint(x: line[0].x/imageView.frame.width, y: line[0].y/imageView.frame.height), CGPoint(x: line[1].x/imageView.frame.width, y: line[1].y/imageView.frame.height)], unit: Float( distanceTextField.text!)!) { (data) in
            
            DispatchQueue.main.async {
                (self.tabBarController as! DataViewController).video?.data = data as? [String : Any]
                (self.tabBarController as! DataViewController).enableAll()
                (self.tabBarController as! DataViewController).selectedIndex = 1
            }
            
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        toggleObjects()
    }
    
    // TO ensure that check boxes are always on the right side of the screen
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        (self.tabBarController as! DataViewController).video!.objects_selected = selectedObjects!
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillTransition(to: CGSize, with: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: to, with: with)
        
        with.animate(alongsideTransition: nil, completion: {
            _ in
            if self.selectButton != nil {
                self.selectButton.applyGradient(colors: self.gradient)
            }
        })
        if tableView != nil {
            tableView.reloadData()
        }
        let image = (self.tabBarController as! DataViewController).video!.thumbnail
        imageWidth = image.size.width
        imageHeight = image.size.height
        
        let proportion = Float(imageWidth!)/Float(imageHeight!)
        var width = Float(to.height - 275)*proportion
        var height = width/proportion
        if width > Float(to.width) {
            height = Float(to.width)/proportion
            width = height*proportion
        }
        
        
        if self.tabBarController?.selectedIndex == 3 {
            imageView.frame = CGRect(x: to.width/2-CGFloat(width)/2, y: to.height/2-CGFloat(height)/2, width: CGFloat(width), height: CGFloat(height))
            canvas.frame = imageView.frame
        }
    }
    
    
    func toggleObjects(){
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.all)
        tabBarController!.navigationItem.title = "Objects"
        view.viewWithTag(100)!.isHidden = true
        view.viewWithTag(101)!.isHidden = true
        tableView.isHidden = false
        distanceTextField.isHidden = true
        for c in distanceTextField.constraints {
            if c.constant == (view.frame.width-60)/2 {
                distanceTextField.removeConstraint(c)
            }
        }
        distanceTextField.widthAnchor.constraint(equalToConstant: CGFloat(100)).isActive = false
        distanceTextField.addConstraint(distanceTextField.widthAnchor.constraint(equalToConstant: CGFloat(0)))
       
        for c in view.constraints {
            if c.constant == 21 {
                view.removeConstraint(c)
            }
        }
        view.addConstraint(view.trailingAnchor.constraint(equalTo: distanceTextField.trailingAnchor, constant: -1))
        self.selectButton.applyGradient(colors: gradient)
    }
    func toggleDistance(){
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
        tabBarController!.navigationItem.title = "Distance"

        view.viewWithTag(100)!.isHidden = false
        view.viewWithTag(101)!.isHidden = false
        tableView.isHidden = true
        distanceTextField.isHidden = false
        for c in distanceTextField.constraints {
            if c.constant == 0 {
                distanceTextField.removeConstraint(c)
            }
        }
        distanceTextField.addConstraint(distanceTextField.widthAnchor.constraint(equalToConstant: CGFloat((view.frame.width-60)/2)))
        for c in view.constraints {
            if c.constant == -1{
                view.removeConstraint(c)
            }
        }
        
        view.addConstraint(view.trailingAnchor.constraint(equalTo: distanceTextField.trailingAnchor, constant: 21))
        self.selectButton.applyGradient(colors: gradient)

    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if keyboardAdjusted == false {
            lastKeyboardOffset = getKeyboardHeight(notification: notification)
            view.frame.origin.y -= lastKeyboardOffset
            keyboardAdjusted = true
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if keyboardAdjusted == true {
            view.frame.origin.y += lastKeyboardOffset
            keyboardAdjusted = false
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
}






