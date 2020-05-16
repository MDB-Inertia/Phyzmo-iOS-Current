//
//  InitialViewController.swift
//  Phyzmo
//
//  Created by Anik Gupta on 11/16/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import Firebase

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "toHomeScreen", sender: self)
        }
        else{
            performSegue(withIdentifier: "toLogIn", sender: self)
        }
    }
}
