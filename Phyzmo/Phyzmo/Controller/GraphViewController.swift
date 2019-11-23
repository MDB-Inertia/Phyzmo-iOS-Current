//
//  GraphViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//
//
//  GraphViewController.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/9/19.
//  Copyright © 2019 Athena. All rights reserved.
//
import UIKit
import Charts

class GraphViewController: UIViewController {


    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var segmentedView: UISegmentedControl!
    
    var chatStatus = 0

    

    var chartDisplacement = [ChartDataEntry]()
    var chartVelocity = [ChartDataEntry]()
    var chartAcceleration = [ChartDataEntry]()
    
    var time : [Double]?
    var rawDisplacement : [Double]?
    var rawVelocity : [Double]?
    var rawAcceleration : [Double]?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGraph()
        updateGraph()
    }

    /*override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
    }*/
    override func viewDidAppear(_ animated: Bool) {
        setUpGraph()
        updateGraph()
        tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(export))
        tabBarController!.navigationItem.title = "Graph"
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
    /***override var shouldAutorotate: Bool {
        return true
    }***/

    override func viewWillDisappear(_ animated: Bool) {
        //UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }
    
    @IBAction func segmentedViewPressed(_ sender: Any) {
        updateGraph()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @objc func export(sender: UIButton) {
        let image = chartView.getChartImage(transparent: false)
        
       // UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd-HH:mm"
        let fileName = "Phyzmo-\(dateFormatterPrint.string(from: Date.init())).png"
        let path = NSURL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        /*var csvText = "Time,Displacement,Velocity,Acceleration\n" //FIXME
        for i in 0..<time!.count {
            let newLine = "\(time![i]),\(rawDisplacement![i]),\(rawVelocity![i]),\(rawAcceleration![i])\n" //FIXME
            csvText += newLine
        }*/
        
        do {
            try image!.pngData()!.write(to: path!)
            
            let vc = UIActivityViewController(activityItems: [path], applicationActivities: [])
            /*vc.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact,
                UIActivity.ActivityType.saveToCameraRoll,
                UIActivity.ActivityType.postToFlickr,
                UIActivity.ActivityType.postToVimeo,
                UIActivity.ActivityType.postToTencentWeibo,
                UIActivity.ActivityType.postToTwitter,
                UIActivity.ActivityType.postToFacebook,
                UIActivity.ActivityType.openInIBooks
            ]*/
            present(vc, animated: true, completion: nil)
            if let popOver = vc.popoverPresentationController {
              popOver.sourceView = self.view
              //popOver.sourceRect =
              popOver.barButtonItem = tabBarController!.navigationItem.rightBarButtonItem
            }
            
        } catch {
            
            print("Failed to create file")
            print("\(error)")
        }
    }
    

    func setUpGraph(){
        readVals()
        chartDisplacement.removeAll()
        chartVelocity.removeAll()
        chartAcceleration.removeAll()
        for i in 0..<time!.count { //FIXME
            let displacementValue = ChartDataEntry(x: time![i], y: rawDisplacement![i])
            let velocityValue = ChartDataEntry(x: time![i], y: rawVelocity![i])
            let accelerationValue = ChartDataEntry(x: time![i], y: rawAcceleration![i])

            chartDisplacement.append(displacementValue)
            chartVelocity.append(velocityValue)
            chartAcceleration.append(accelerationValue)
        }
        
    }
    func updateGraph(){

        var currentLine = LineChartDataSet(entries: chartDisplacement, label: "Displacement" )
    
        if segmentedView.selectedSegmentIndex == 0 {
            var currentLine = LineChartDataSet(entries: chartDisplacement, label: "Displacement" )
        }
        else if segmentedView.selectedSegmentIndex == 1 {
            currentLine = LineChartDataSet(entries: chartVelocity, label: "Velocity" )
        }
        
        else if segmentedView.selectedSegmentIndex == 2 {
              currentLine = LineChartDataSet(entries: chartAcceleration, label: "Acceleration" )
            
        }
        
        
        currentLine.colors = [UIColor(red:0.01, green:0.51, blue:0.93, alpha:1.0)]
        currentLine.lineWidth = 2.0
        currentLine.circleColors = [UIColor(red:0.44, green:0.80, blue:0.92, alpha:1.0)]
        currentLine.circleRadius = 4.0
        let data = LineChartData()
        data.addDataSet(currentLine)
        chartView.data = data
        chartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0, easingOption: .easeInSine)
    }
    
    


}
