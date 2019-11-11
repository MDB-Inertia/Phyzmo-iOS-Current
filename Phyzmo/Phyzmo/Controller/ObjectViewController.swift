//
//  ObjectViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit

class ObjectViewController: UIViewController {

    var video : Video?
    @IBOutlet weak var objects: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tabController = self.tabBarController as! DataViewController
        self.video = tabController.video
        print("\(video?.objects_detected!))")
        objects.text = "\(video!.objects_detected!))"
    }
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    

}
