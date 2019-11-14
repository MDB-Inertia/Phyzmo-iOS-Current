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
    @IBOutlet weak var chartButton: UIButton!
    @IBOutlet weak var exportButton: UIButton!
    
    
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

    override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
    }
    override func viewDidAppear(_ animated: Bool) {
        setUpGraph()
        updateGraph()
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
    override var shouldAutorotate: Bool {
        return true
    }

    override func viewWillDisappear(_ animated: Bool) {
        //UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
    }

    @IBAction func chartButtonPressed(_ sender: Any) {
        if chatStatus == 2{
            chatStatus = 0}
        else{
            chatStatus += 1}

        updateGraph()

    }
    
    @IBAction func exportButtonPressed(_ sender: Any) {
        let image = chartView.getChartImage(transparent: false)
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
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
    
        if chatStatus == 1 {
            currentLine = LineChartDataSet(entries: chartVelocity, label: "Velocity" )
        }
        else if chatStatus == 2 {
            currentLine = LineChartDataSet(entries: chartAcceleration, label: "Acceleration" )
        }

        currentLine.colors = [NSUIColor.blue]

        let data = LineChartData()
        data.addDataSet(currentLine)
        chartView.data = data

    }
    
    


}
