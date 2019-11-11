//
//  ObjectViewController - TableFunctions.swift
//  Phyzmo
//
//  Created by Anik Gupta on 11/10/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import UIKit

extension ObjectViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return video!.objects_detected!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = indexPath[1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath) as! ObjectTableViewCell
        cell.checkMark = nil
        cell.awakeFromNib()
        let size = CGSize(width: tableView.frame.width, height: height(for: indexPath))
        cell.initCellFrom(size: size)
        cell.object = video!.objects_detected![indexPath.row]
        cell.objects_detected = video!.objects_detected!
        cell.objects_selected = video!.objects_selected
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath[1]
        checkPressed(cell: tableView.cellForRow(at: indexPath) as! ObjectTableViewCell)
        //selectedEvent = events[index]
        //performSegue(withIdentifier: "showDetails", sender: self)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height(for: indexPath)
    }
    
    func height(for index: IndexPath) -> CGFloat {
        return 60
    }
    
    func checkPressed(cell: ObjectTableViewCell){
        if cell.checkMark != nil {
            cell.checkMark.checked = !cell.checkMark.checked
            if video!.objects_selected.contains(cell.object!) {
                video!.objects_selected.remove(at: video!.objects_selected.firstIndex(of: cell.object!)!)
            }
            else{
                video!.objects_selected.append(cell.object!)
            }
        }
        print(video!.objects_selected)
    }
    
}
