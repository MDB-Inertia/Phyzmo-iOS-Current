//
//  DataViewController.swift
//  Phyzmo
//
//  Created by Anik Gupta on 11/10/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit

class DataViewController: UITabBarController {

    var video : Video?
    override func viewDidLoad() {
        super.viewDidLoad()
        print("hi")
        if video != nil{
            if video?.objects_selected == [] || video?.line == nil || video?.line == [] || video?.unit == nil{
                disableAllButObjects()
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent{
            video?.deconstruct()
            print(video?.objects_selected)
        }
    }
    func disableAllButObjects(){
        var count = 0
        for button in self.tabBar.items!{
            if button.title != "Objects" {
                button.isEnabled = false
            }
            else{
                self.selectedIndex = count
            }
            count += 1
        }
    }
    func enableAll(){
        for button in self.tabBar.items!{
            button.isEnabled = true
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationItem.title = "Video"
    }
}
