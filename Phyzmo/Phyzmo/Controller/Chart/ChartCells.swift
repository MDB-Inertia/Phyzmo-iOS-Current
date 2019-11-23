//
//  ChartCells.swift
//  Phyzmo
//
//  Created by Athena Leong on 11/14/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import SpreadsheetView
import UIKit

class HeaderCell: Cell{
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
            BorderStyle.solid(width: 1, color: .label)
             label.textColor = .label
        } else {
            backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            BorderStyle.solid(width: 1, color: .black)
             label.textColor = .black
            // Fallback on earlier versions
        }//
        
        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
       

        contentView.addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
    
class TextCell: Cell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.frame = bounds
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        
        
        
        if #available(iOS 13.0, *) {
            label.textColor = .label
            backgroundColor = .systemBackground
            BorderStyle.solid(width: 1, color: .label)
        } else {
            label.textColor = .black
            backgroundColor = UIColor(white: 0.95, alpha: 1.0)
            BorderStyle.solid(width: 1, color: .black)
            // Fallback on earlier versions
        }
        //
        contentView.addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

    

