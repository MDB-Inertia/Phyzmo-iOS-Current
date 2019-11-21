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
        return (self.tabBarController as! DataViewController).video!.objects_detected!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = indexPath[1]
        let cell = tableView.dequeueReusableCell(withIdentifier: "objectCell", for: indexPath) as! ObjectTableViewCell
        cell.checkMark = nil
        cell.awakeFromNib()
        let size = CGSize(width: tableView.frame.width, height: height(for: indexPath))
        cell.initCellFrom(size: size)
        cell.object = (self.tabBarController as! DataViewController).video!.objects_detected![indexPath.row]
        cell.objects_detected = (self.tabBarController as! DataViewController).video!.objects_detected!
        cell.objects_selected = (self.tabBarController as! DataViewController).video!.objects_selected
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var index = indexPath[1]
        checkPressed(cell: tableView.cellForRow(at: indexPath) as! ObjectTableViewCell)
        if (self.tabBarController as! DataViewController).video!.objects_selected == []{
            selectButton.isHighlighted = true
            selectButton.isEnabled = false
        }
        else{
            selectButton.isHighlighted = false
            selectButton.isEnabled = true
        }
        if selectedObjects == []{
            (self.tabBarController as! DataViewController).disableAllButObjects()
        }

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
            if (self.tabBarController as! DataViewController).video!.objects_selected.contains(cell.object!) {
                (self.tabBarController as! DataViewController).video!.objects_selected.remove(at: (self.tabBarController as! DataViewController).video!.objects_selected.firstIndex(of: cell.object!)!)
            }
            else{
                (self.tabBarController as! DataViewController).video!.objects_selected.append(cell.object!)
            }
        }
        print((self.tabBarController as! DataViewController).video!.objects_selected)
    }
    
}
