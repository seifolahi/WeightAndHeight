//
//  WeightMeterView.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/10/21.
//

import UIKit

protocol WeightMeterDelegate {
    func onWheelTick(value: CGFloat)
}

class WeightMeterView: UIView {
    
    var delegate: WeightMeterDelegate?
    
    private var backLayer: CALayer?
    private var innerFrameLayer: CALayer?
    private var outerFrameLayer: CALayer?
    private var overlayLayer: CALayer?
    
    private var previousTouchPoint = CGPoint.zero
    private var currentTouchPoint = CGPoint.zero
    private var wheelValueInProgress = CGFloat(0)
    private var startTransform = CGAffineTransform.identity
    
    var minValue: Int = 0
    var maxValue: Int = 99
    var valueStep: Int = 5
    var wheelValue: CGFloat = 0
    var numbersFont: UIFont = .systemFont(ofSize: 18)
    var lockOnBoundry = false
    var boundrySpace: CGFloat = CGFloat.pi / 2
    
    var wheelHapticValue: CGFloat = 0
    
    init() {
        super.init(frame: .zero)
        
        let pang = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(gesture:)))
        addGestureRecognizer(pang)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        refreshBackgroundShape()
//        refreshFrameShape()
//        refreshOverlayLayer()
//    }
    
    override func draw(_ rect: CGRect) {
        refreshBackgroundShape()
        refreshFrameShape()
        refreshOverlayLayer()
    }
    
    private func refreshBackgroundShape() {

        let backLayer = WeightBackgroundLayer()
        backLayer.minValue = minValue
        backLayer.maxValue = maxValue
        backLayer.step = valueStep
        backLayer.numbersFont = numbersFont
        backLayer.boundrySpace = boundrySpace
        backLayer.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width)

        if let oldBackLayer = self.backLayer {
            self.layer.replaceSublayer(oldBackLayer, with: backLayer)
        } else {
            self.layer.insertSublayer(backLayer, at: 0)
        }
        self.backLayer = backLayer
        backLayer.display()
    }
    
    private func refreshOverlayLayer() {
        let overlayLayer = WeightOverlayLayer()
        overlayLayer.frame = bounds
        overlayLayer.shadowOffset = CGSize(width:0, height:0)
        overlayLayer.shadowRadius = 6
        overlayLayer.shadowColor = UIColor.black.cgColor
        overlayLayer.shadowOpacity = 0.6

        if let oldOverlayLayer = self.overlayLayer {
            self.layer.replaceSublayer(oldOverlayLayer, with: overlayLayer)
        } else {
            self.layer.insertSublayer(overlayLayer, at: 0)
        }
        self.overlayLayer = overlayLayer
        overlayLayer.display()
    }
    
    private func refreshFrameShape() {
        
        let innerFrameLayer = InnerWeightFrameLayer()
        innerFrameLayer.frame = bounds
        innerFrameLayer.updatePath()
        
        if let oldInnerFrameLayer = self.innerFrameLayer {
            self.layer.replaceSublayer(oldInnerFrameLayer, with: innerFrameLayer)
        } else {
            self.layer.insertSublayer(innerFrameLayer, at: 0)
        }
        self.innerFrameLayer = innerFrameLayer
        
        let outerFrameLayer = OuterWeightFrameLayer()
        outerFrameLayer.frame = bounds
        outerFrameLayer.updatePath()
        
        if let oldOuterFrameLayer = self.outerFrameLayer {
            self.layer.replaceSublayer(oldOuterFrameLayer, with: outerFrameLayer)
        } else {
            self.layer.insertSublayer(outerFrameLayer, at: 0)
        }
        self.outerFrameLayer = outerFrameLayer
    }
    
    @objc func onPan(gesture: UIPanGestureRecognizer) {
        
        guard let backLayer = backLayer else { return }
        
        switch gesture.state {
        case .began:
            previousTouchPoint = gesture.location(in: self)
            startTransform = backLayer.affineTransform()
        case .changed:
            currentTouchPoint = gesture.location(in: self)

            rotateWheelLayer()
            hapticBeepIfNeeded()
            
            let tmpFinalWheelValue = (wheelValue + wheelValueInProgress).truncatingRemainder(dividingBy: CGFloat(maxValue - minValue)) + CGFloat(minValue)
            delegate?.onWheelTick(value: tmpFinalWheelValue)
            
        case .ended:
            wheelValue += wheelValueInProgress
            
        default:
            break
        }
    }
    
    func rotateWheelLayer() {

        guard let backLayer = backLayer else { return }

        backLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let myCenter = CGPoint(x: backLayer.bounds.width / 2, y: 200)
        let previousAngle = atan2f(Float(previousTouchPoint.y - myCenter.y),
                                   Float(previousTouchPoint.x - myCenter.x))

        let currentAngle = atan2f(Float(currentTouchPoint.y - myCenter.y),
                                  Float(currentTouchPoint.x - myCenter.x))

        let extraRotation = CGFloat(currentAngle - previousAngle)
        
        
        let blockWidth = ((2 * CGFloat.pi) - (boundrySpace)) / CGFloat(maxValue - minValue)
        
        let tmpWheelValueInProgress = -(extraRotation / blockWidth)
        
        if true {
            backLayer.setAffineTransform(startTransform.rotated(by: extraRotation))
            wheelValueInProgress = tmpWheelValueInProgress
        }
    }

    func hapticBeepIfNeeded() {

        let lastValue = wheelHapticValue
        wheelHapticValue = wheelValueInProgress / CGFloat(valueStep)
        
        if floor(lastValue) != floor(wheelHapticValue) {
            UISelectionFeedbackGenerator().selectionChanged()
            print(floor(wheelHapticValue))
        }
    }
}
