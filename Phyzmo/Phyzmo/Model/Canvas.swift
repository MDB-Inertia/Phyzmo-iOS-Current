//
//  Canvas.swift
//  Phyzmo
//
//  Created by Patrick Yin on 11/16/19.
//  Copyright © 2019 Athena. All rights reserved.
//

import Foundation
import UIKit

class Canvas: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {return}
        
        for (i, p) in line.enumerated() {
            if i == 0 {
                context.move(to: p)
            } else {
                context.addLine(to: p)
            }
        }
        
        context.setStrokeColor(UIColor.green.cgColor)
        context.setLineWidth(8)
        context.setLineCap(.butt)
        
        context.strokePath()
    }
    
    var line = [CGPoint]()
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: nil) else {return}
        
        if !isInArray(point: point, line: line) {
            if line.count > 1 {
                line.remove(at: 0)
            }
            line.append(point)
            print(point)
        }
        setNeedsDisplay()
    }
    
    func isInArray(point: CGPoint, line: [CGPoint]) -> Bool {
        for e in line {
            if (point.x == e.x && point.y == e.y) {
                return true
            }
        }
        return false
    }
}

//class ViewController: UIViewController {
//    let canvas = Canvas()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.addSubview(canvas)
//        canvas.backgroundColor = .white
//        canvas.frame = view.frame
//    }
//}
