//
//  ChartExtension.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/14/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import SpreadsheetView

extension ChartViewController: SpreadsheetViewDataSource, SpreadsheetViewDelegate{
    
    //FIXME
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        let size = (UIScreen.main.bounds.height * 0.75) / 4
        print(size)
        return size
    }
    
     func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return 40
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 4
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1 + time!.count
    }

    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch (indexPath.column, indexPath.row) {
        case (0, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = "Time"
            cell.gridlines.left = .default
            cell.gridlines.right = .none
            return cell
        case (1, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = "Displacement"
            cell.gridlines.left = .solid(width: 1 / UIScreen.main.scale, color: cell.backgroundColor!)
            cell.gridlines.right = cell.gridlines.left
            return cell
        case (2, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = "Velocity"
            //cell.label.textColor = .gray
            cell.gridlines.left = .none
            cell.gridlines.right = .default
            return cell
        case (3, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            cell.label.text = "Acceleration"
            //cell.label.textColor = .gray
            cell.gridlines.left = .none
            cell.gridlines.right = .default
            return cell
        case (0, 1..<time!.count):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text =  String(time![indexPath.row - 1].rounded(toPlaces: 3))
            cell.gridlines.left = .none
            cell.gridlines.right = .default
            return cell
        case (1, 1..<time!.count):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text =  String(rawDisplacement![indexPath.row - 1].rounded(toPlaces: 3))
            cell.gridlines.left = .none
            cell.gridlines.right = .default
            return cell
        case (2, 1..<time!.count):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text =  String(rawVelocity![indexPath.row - 1].rounded(toPlaces: 3))
            cell.gridlines.left = .none
            cell.gridlines.right = .default
            return cell
        case (3, 1..<time!.count):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text =  String(rawAcceleration![indexPath.row - 1].rounded(toPlaces: 3))
            cell.gridlines.left = .none
            cell.gridlines.right = .default
            return cell
        default:
            return nil
        }
    }
}
extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

