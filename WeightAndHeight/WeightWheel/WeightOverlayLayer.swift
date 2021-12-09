//
//  WeightOverlayLayer.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/10/21.
//

import UIKit

class WeightOverlayLayer: CALayer {
    override func draw(in ctx: CGContext) {
        
        let WIDTH = frame.width
        
        ctx.setFillColor(UIColor.red.cgColor)
        
        ctx.fill(CGRect(x: (WIDTH / 2) , y: 4, width: 3, height: 50))
        ctx.fillEllipse(in: CGRect(x: (WIDTH / 2) - 5, y: 54, width: 12, height: 12))
        
    }
}
