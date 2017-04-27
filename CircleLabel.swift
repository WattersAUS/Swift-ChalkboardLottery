//
//  CircleLabel.swift
//  ChalkboardLottery
//
//  Created by Graham Watson on 26/04/2017.
//  Copyright © 2017 Graham Watson. All rights reserved.
//

import UIKit

class CircleLabel: UILabel {

    var borderWidth: CGFloat   = 0
    var displayColour: UIColor = UIColor.clear
    var displayType: numberDisplayType = numberDisplayType.Number {
        didSet {
            switch self.displayType {
            case numberDisplayType.Default:
                self.displayColour = UIColor.clear
                break
            case numberDisplayType.Number:
                self.displayColour = UIColor.cyan
                self.displayColour = UIColor.clear
                break
            case numberDisplayType.Special:
                self.displayColour = UIColor.brown
                break
            case numberDisplayType.Bonus:
                self.displayColour = UIColor.black
                break
            }
        }
    }
    
    //
    // override to draw label as a cirle with a border (if size is set), then hand back to the super function to carry on
    //
    override func draw(_ rect: CGRect) {
        var path: UIBezierPath
        
        self.displayColour.setFill()
        if self.borderWidth != 0 {
            let inside: CGRect = CGRect(x: rect.minX   + self.borderWidth,
                                        y: rect.minY   + self.borderWidth,
                                    width: rect.width  - (2 * self.borderWidth),
                                   height: rect.height - (2 * self.borderWidth))
            path = UIBezierPath(ovalIn: inside)
            UIColor.white.setStroke()
            path.lineWidth = (2 * self.borderWidth)
            path.fill()
            path.stroke()
        } else {
            path = UIBezierPath(ovalIn: rect)
            path.fill()
        }
        super.draw(rect)
    }
    
}
