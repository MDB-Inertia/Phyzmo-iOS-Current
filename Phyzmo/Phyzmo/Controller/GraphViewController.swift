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
    let documentInteractionController = UIDocumentInteractionController()


    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGraph()
        updateGraph()
        documentInteractionController.delegate = self

    }

    /*override func viewWillAppear(_ animated: Bool) {
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
    }*/
    override func viewDidAppear(_ animated: Bool) {
        setUpGraph()
        updateGraph()
        tabBarController!.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(export))
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
        //UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        storeAndShare(withURLString: "https://images5.alphacoders.com/581/581655.jpg")
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
        

        currentLine.colors = [NSUIColor.blue]

        let data = LineChartData()
        data.addDataSet(currentLine)
        chartView.data = data

    }
    
    


}
extension GraphViewController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
            }
        }.resume()
    }
}

extension GraphViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
