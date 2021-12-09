//
//  WeightBackgroundLayer.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/10/21.
//

import UIKit

class WeightBackgroundLayer: CALayer {
    
    override func draw(in ctx: CGContext) {
        
        let WIDTH = frame.width
        
        let attrs: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        ctx.setFillColor(UIColor.red.cgColor)
        
        for i in 0...99 {
            let tmpLineHeight = (i % 5 == 0) ? CGFloat(9) : CGFloat(6)
            
            ctx.fill(CGRect(x: (WIDTH / 2) , y: 6, width: 2, height: tmpLineHeight))
            
            if (i % 5 == 0) {
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
