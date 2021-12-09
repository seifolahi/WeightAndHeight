//
//  WeightMeter.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/10/21.
//

import UIKit

class WeightMeter: UIView {
    
    private var backLayer: CALayer?
    private var shapeLayer: CALayer?
    private var overlayLayer: CALayer?
    
    private var previousTouchPoint = CGPoint.zero
    private var rotation = CGFloat(0)
    private var startTransform = CGAffineTransform.identity
    private var lastRoundWheelValue = CGFloat(0)
    
    init() {
        super.init(frame: .zero)
        
        let pang = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(gesture:)))
        addGestureRecognizer(pang)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        refreshBackgroundShape()
        refreshFrameShape()
        refreshOverlayLayer()
    }
    
    private func refreshBackgroundShape() {

        let backLayer = WeightBackgroundLayer()

        if let oldBackLayer = self.backLayer {
            self.layer.replaceSublayer(oldBackLayer, with: backLayer)
        } else {
            backLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)
            self.layer.insertSublayer(backLayer, at: 0)
        }
        self.backLayer = backLayer
        backLayer.display()
    }
    
    private func refreshOverlayLayer() {
        let overlayLayer = WeightOverlayLayer()
        
        overlayLayer.shadowOffset = CGSize(width:0, height:0)
        overlayLayer.shadowRadius = 6
        overlayLayer.shadowColor = UIColor.black.cgColor
        overlayLayer.shadowOpacity = 0.6

        if let oldOverlayLayer = self.overlayLayer {
            self.layer.replaceSublayer(oldOverlayLayer, with: overlayLayer)
        } else {
            overlayLayer.frame = bounds
            self.layer.insertSublayer(overlayLayer, at: 0)
        }
        self.overlayLayer = overlayLayer
        overlayLayer.display()
    }
    
    private func refreshFrameShape() {
        
        backgroundColor = .lightGray
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPath()
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.shadowOffset = CGSize(width:0, height:0)
        shapeLayer.shadowRadius = 6
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 0.4
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = createPathForRemovingFrameShadow()
        shapeLayer.mask = maskLayer
        
        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
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
    
    @objc func onPan(gesture: UIPanGestureRecognizer) {
        
        guard let backLayer = backLayer else { return }
        
        switch gesture.state {
        case .began:
            previousTouchPoint = gesture.location(in: self)
            startTransform = backLayer.affineTransform()
        case .changed:
            let currentTouchPoint = gesture.location(in: self)

            backLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            let myCenter = CGPoint(x: backLayer.bounds.width / 2, y: 200)
            let previousAngle = atan2f(Float(previousTouchPoint.y - myCenter.y),
                                       Float(previousTouchPoint.x - myCenter.x))
            
            let currentAngle = atan2f(Float(currentTouchPoint.y - myCenter.y),
                                      Float(currentTouchPoint.x - myCenter.x))

            rotation = CGFloat(currentAngle - previousAngle)
            backLayer.setAffineTransform(startTransform.rotated(by: rotation))
            let blockWidth = (CGFloat.pi / 50)
            let tapticStep = CGFloat(5)
            let tmpLastRoundWheelValue = lastRoundWheelValue
            lastRoundWheelValue = floor((rotation / blockWidth) / tapticStep)
            if tmpLastRoundWheelValue != lastRoundWheelValue {
                UISelectionFeedbackGenerator().selectionChanged()
            }
            
        case .ended:
            break
        default:
            break
        }
    }
}
