//
//  WeightFrameLayer.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/10/21.
//

import UIKit

class WeightFrameLayer: CAShapeLayer {
    
    func updatePath() {
        
        path = createPath()
        fillColor = UIColor.white.cgColor
        shadowOffset = CGSize(width:0, height:0)
        shadowRadius = 6
        shadowColor = UIColor.black.cgColor
        shadowOpacity = 0.4
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = createPathForRemovingFrameShadow()
        mask = maskLayer
    }
    
    func createPath() -> CGPath {
        
        let HEIGHT = CGFloat(200)
        let DENT_WIDTH = CGFloat(66)
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: HEIGHT))
        
        path.addArc(withCenter: CGPoint(x: frame.width/2, y: HEIGHT),
                    radius: frame.width/2,
                    startAngle: CGFloat.pi,
                    endAngle: 0,
                    clockwise: true)
        
        
        path.addLine(to: CGPoint(x: frame.width - DENT_WIDTH, y: HEIGHT))


        path.addArc(withCenter: CGPoint(x: frame.width/2, y: HEIGHT),
                    radius: frame.width/2 - DENT_WIDTH,
                    startAngle: 0,
                    endAngle: CGFloat.pi,
                    clockwise: false)


        path.addLine(to: CGPoint(x: frame.width, y: HEIGHT))
        path.addLine(to: CGPoint(x: frame.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))

        path.close()
        
        return path.cgPath
    }
    
    
    func createPathForRemovingFrameShadow() -> CGPath {
        
        let HEIGHT = frame.width
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: HEIGHT))
        path.addLine(to: CGPoint(x: HEIGHT, y: HEIGHT))
        path.addLine(to: CGPoint(x: HEIGHT, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))

        path.close()
        
        return path.cgPath
    }
}
