//
//  VideoViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import AVKit

class VideoViewController: UIViewController {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    let playerViewController = AVPlayerViewController()
    override func viewDidLoad(){
       super.viewDidLoad()
        
        image.image = (self.tabBarController as! DataViewController).video?.thumbnail
        playButton.frame = image.frame
        playerViewController.player = (self.tabBarController as! DataViewController).video?.video
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tabBarController!.navigationItem.rightBarButtonItem = nil
        tabBarController!.navigationItem.title = "Video"
    }
    
    @IBAction func playPressed(_ sender: Any) {
        present(playerViewController, animated: true) {
            (self.tabBarController as! DataViewController).video?.video!.seek(to: .zero)
            (self.tabBarController as! DataViewController).video?.video!.play()
        }
    }
}
