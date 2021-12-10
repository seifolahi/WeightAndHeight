//
//  WeightBackgroundLayer.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/10/21.
//

import UIKit

class WeightBackgroundLayer: CALayer {
    
    var minValue: Int = 0
    var maxValue: Int = 0
    var step: Int = 0
    var numbersFont = UIFont.systemFont(ofSize: 18)
    
    override func draw(in ctx: CGContext) {
        
        let WIDTH = frame.width
        
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: numbersFont]
        ctx.setFillColor(UIColor.red.cgColor)
        
        for i in minValue...maxValue {
            let tmpLineHeight = (i % step == 0) ? CGFloat(9) : CGFloat(6)
            
            ctx.fill(CGRect(x: (WIDTH / 2) , y: 6, width: 2, height: tmpLineHeight))
            
            if (i % step == 0) {
                UIGraphicsPushContext(ctx)
                let str = "\(i)" as NSString
                let strSize = str.size(withAttributes: attrs)
                str.draw(at: CGPoint(x: (WIDTH / 2) - (strSize.width / 2), y: 20), withAttributes: attrs)
                UIGraphicsPopContext()
            }
            
            ctx.translateBy(x: (WIDTH / 2), y: (WIDTH / 2))
            ctx.rotate(by: CGFloat.pi / 49.5)
            ctx.translateBy(x: -(WIDTH / 2), y: -(WIDTH / 2))
        }
    }
}
