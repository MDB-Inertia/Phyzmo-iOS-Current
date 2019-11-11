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
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
