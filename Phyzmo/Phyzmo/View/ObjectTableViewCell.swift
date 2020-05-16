//
//  ObjectTableViewCell.swift
//  Phyzmo
//
//  Created by Anik Gupta on 11/10/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import UIKit
import CheckMarkView

class ObjectTableViewCell: UITableViewCell{
    
    var object: String? {
        didSet {
            if let object = object {
                objectName.text = object.capitalized
            }
        }
    }
    var objects_selected : [String]? {
        didSet {
            if let objects_selected = objects_selected {
                checkMark.checked = objects_selected.contains(object!)
            }
        }
    }
    
    var objects_detected : [String]?
    var objectName: UILabel!
    var checkMark : CheckMarkView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func initCellFrom(size: CGSize) {
        
        objectName = UILabel(frame: CGRect(x: 20, y: size.height-40, width: size.width-40, height: 20))
        objectName.numberOfLines = 0
        objectName.adjustsFontSizeToFitWidth = true
        objectName.minimumScaleFactor = 0.3
        objectName.font = UIFont(name: "System", size: 20)
        objectName.textAlignment = .left
        contentView.addSubview(objectName)
        
        checkMark = CheckMarkView(frame: CGRect(x: size.width-50, y: size.height-45, width: 30, height: 30))
        checkMark.checked = true
        checkMark.style = .openCircle
        checkMark.contentMode = .scaleAspectFit
        checkMark.backgroundColor = .clear
        contentView.addSubview(checkMark)
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        checkMark.removeFromSuperview()
        objectName.removeFromSuperview()
    }

}
