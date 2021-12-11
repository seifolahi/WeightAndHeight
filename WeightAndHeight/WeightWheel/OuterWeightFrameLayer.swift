//
//  OuterWeightFrameLayer.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/10/21.
//

import UIKit


class OuterWeightFrameLayer: CAShapeLayer {
    
    func updatePath() {
        
        path = createPath()
        fillColor = UIColor.white.cgColor
        shadowOffset = CGSize(width:0, height:0)
        shadowRadius = 6
        shadowColor = UIColor.black.cgColor
        shadowOpacity = 0.4
    }
    
    func createPath() -> CGPath {
        
        let center = frame.width / 2
        let DENT_WIDTH = CGFloat(66)
        
        let path = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: center, y: center),
                    radius: center,
                    startAngle: 0,
                    endAngle: 2 * CGFloat.pi,
                    clockwise: true)
        
        path.close()
        
        return path.cgPath
    }
}
