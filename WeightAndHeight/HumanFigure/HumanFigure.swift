//
//  HumanFigure.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/10/21.
//

import UIKit

class HumanFigure: UIView {
    
    private var shapeLayer: CALayer?
    
    var fatness: CGFloat = 0 {
        didSet {
            refreshShape()
        }
    }
    
    override func draw(_ rect: CGRect) {
        refreshShape()
    }
    
    private func refreshShape() {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.blue.cgColor
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    func createPath() -> CGPath {
        
        let shape = UIBezierPath()
        
        shape.addArc(withCenter: CGPoint(x: 50, y: 11),
                     radius: 7,
                     startAngle: CGFloat.pi / 2,
                     endAngle: CGFloat.pi / 2  +  (CGFloat.pi * 2),
                     clockwise: true)
        

        shape.addLine(to: CGPoint(x: 50, y: 20))
        shape.addLine(to: CGPoint(x: 60, y: 20))
        
        shape.addLine(to: CGPoint(x: 78, y: 48))
        shape.addLine(to: CGPoint(x: 73, y: 52))
        shape.addLine(to: CGPoint(x: 60, y: 32))
        
        
        shape.addCurve(to: CGPoint(x: 60, y: 95),
                       controlPoint1: CGPoint(x: 60 + fatness, y: 35),
                       controlPoint2: CGPoint(x: 60 + fatness, y: 40))
        
        
        shape.addLine(to: CGPoint(x: 51, y: 95))
        shape.addLine(to: CGPoint(x: 51, y: 60))
        shape.addLine(to: CGPoint(x: 49, y: 60))
        shape.addLine(to: CGPoint(x: 49, y: 95))
        shape.addLine(to: CGPoint(x: 40, y: 95))
        
        shape.addCurve(to: CGPoint(x: 40, y: 32),
                       controlPoint1: CGPoint(x: 40 - fatness, y: 35),
                       controlPoint2: CGPoint(x: 40 - fatness, y: 40))
        
        shape.addLine(to: CGPoint(x: 27, y: 52))
        shape.addLine(to: CGPoint(x: 22, y: 48))
        shape.addLine(to: CGPoint(x: 40, y: 20))
        
        
        shape.addLine(to: CGPoint(x: 50, y: 20))
        
        shape.close()
        
        return shape.cgPath
    }
}
