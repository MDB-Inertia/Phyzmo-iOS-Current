//
//  ChartViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {
    
    var time : [Double]?
    var rawDisplacement : [Double]?
    var rawVelocity : [Double]?
    var rawAcceleration : [Double]?

    @IBOutlet weak var exportButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    //EXPORT
    
    @IBAction func exportButtonPressed(_ sender: Any) {
        readVals()
        let fileName = "\((self.tabBarController as! DataViewController).video?.id)"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        var csvText = "Time,Displacement,Velocity,Acceleration\n" //FIXME
        for i in 0..<time!.count {
            let newLine = "\(time![i]),\(rawDisplacement![i]),\(rawVelocity![i]),\(rawAcceleration![i])\n" //FIXME
            csvText += newLine
        }
        
        do {
            try csvText.write(to: path!, atomically: true, encoding: String.Encoding.utf8)
            
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            vc.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.openInIBooks
            ]
            present(vc, animated: true, completion: nil)
            
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
    }
    
    func readVals(){
        guard let data = (self.tabBarController as! DataViewController).video?.data else{
            return
        }
        time = data["time"]! as! [Double]
        rawDisplacement = data["total_distance"]! as! [Double]
        rawVelocity = data["normalized_velocity"]! as! [Double]
        rawAcceleration = data["normalized_acce"]! as! [Double]
        print("\n\(time)")
        print("\n\(rawDisplacement)")
        print("\n\(rawVelocity)")
        print("\n\(rawAcceleration)")
    }
    
    
    

}
