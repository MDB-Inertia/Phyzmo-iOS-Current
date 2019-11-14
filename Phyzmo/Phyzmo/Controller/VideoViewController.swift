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
       
        //playButton.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 50, height: 50))
        playButton.frame = image.frame
        //playButton.imageView?.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 50, height: 50))
        playerViewController.player = (self.tabBarController as! DataViewController).video?.video

        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func playPressed(_ sender: Any) {
        present(playerViewController, animated: true) {
            (self.tabBarController as! DataViewController).video?.video!.play()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
         UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    

}
