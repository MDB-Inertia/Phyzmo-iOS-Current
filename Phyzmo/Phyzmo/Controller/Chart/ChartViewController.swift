//
//  ChartViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import SpreadsheetView

class ChartViewController: UIViewController {
    
    var time : [Double]?
    var rawDisplacement : [Double]?
    var rawVelocity : [Double]?
    var rawAcceleration : [Double]?

    @IBOutlet weak var chartSpreadsheetView: SpreadsheetView!
    
    let colors = [UIColor(red: 0.314, green: 0.698, blue: 0.337, alpha: 1),
    UIColor(red: 1.000, green: 0.718, blue: 0.298, alpha: 1),
    UIColor(red: 0.180, green: 0.671, blue: 0.796, alpha: 1)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readVals()
        
        

        
        chartSpreadsheetView.dataSource = self
        chartSpreadsheetView.delegate = self
        
        let hairline = 1 / UIScreen.main.scale
               chartSpreadsheetView.intercellSpacing = CGSize(width: hairline, height: hairline)
               chartSpreadsheetView.gridStyle = .solid(width: hairline, color: .lightGray)

        chartSpreadsheetView.register(HeaderCell.self, forCellWithReuseIdentifier: String(describing: HeaderCell.self))
        chartSpreadsheetView.register(TextCell.self, forCellWithReuseIdentifier: String(describing: TextCell.self))
        
        chartSpreadsheetView.bounces = false
        
        
    }
    /*override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
    }*/
    
    override func viewDidAppear(_ animated: Bool){
        chartSpreadsheetView.flashScrollIndicators()
        tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(export))
        
    }
    /**
    override var shouldAutorotate: Bool {
        return true
    }**/
    
    //EXPORT
    @objc func export(sender: UIButton) {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd-HH:mm"
        let fileName = "Phyzmo-\(dateFormatterPrint.string(from: Date.init())).csv"
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
