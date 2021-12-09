//
//  ViewController.swift
//  WeightAndHeight
//
//  Created by Hamid reza Seifolahi on 12/7/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configGeneralUI()
        configHumanFigure()
        configMeter()
        configWeight()
    }
    
    func configGeneralUI() {
        view.backgroundColor = .white
    }
    
    func configHumanFigure() {
        let figure = HumanFigure()
        figure.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(figure)
        
        figure.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        figure.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        figure.widthAnchor.constraint(equalToConstant: 100).isActive = true
        figure.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        figure.layer.borderColor = UIColor.gray.cgColor
        figure.layer.borderWidth = 1
        figure.transform = CGAffineTransform.identity.scaledBy(x: 2, y: 2)
    }
    
    func configMeter() {
        
    }
    
    func configWeight() {
        let weighter = WeightMeter()
        weighter.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(weighter)
        
        weighter.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        weighter.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        weighter.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        weighter.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}

class WeightMeter: UIView {
    
    private var backLayer: CALayer?
    private var shapeLayer: CALayer?
    private var overlayLayer: CALayer?
    
    init() {
        super.init(frame: .zero)
        
        let pang = UIPanGestureRecognizer(target: self, action: #selector(self.onPan(gesture:)))
        addGestureRecognizer(pang)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var previousTouchPoint = CGPoint.zero
    var rotation = CGFloat(0)
    var startTransform = CGAffineTransform.identity
    var lastRoundWheelValue = CGFloat(0)
    
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
                print("\(lastRoundWheelValue)")
                UISelectionFeedbackGenerator().selectionChanged()
            }
            
        case .ended:
            break
        default:
            break
        }
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
        
        let shapeLayer2 = CAShapeLayer()
        shapeLayer2.path = createPath2()
        shapeLayer.mask = shapeLayer2
        
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
    
    
    func createPath2() -> CGPath {
        
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


class HumanFigure: UIView {
    
    private var shapeLayer: CALayer?
    
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
        
        let fat = CGFloat(15)
        
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
                       controlPoint1: CGPoint(x: 60 + fat, y: 35),
                       controlPoint2: CGPoint(x: 60 + fat, y: 40))
        
        
        shape.addLine(to: CGPoint(x: 51, y: 95))
        shape.addLine(to: CGPoint(x: 51, y: 60))
        shape.addLine(to: CGPoint(x: 49, y: 60))
        shape.addLine(to: CGPoint(x: 49, y: 95))
        shape.addLine(to: CGPoint(x: 40, y: 95))
        
        shape.addCurve(to: CGPoint(x: 40, y: 32),
                       controlPoint1: CGPoint(x: 40 - fat, y: 35),
                       controlPoint2: CGPoint(x: 40 - fat, y: 40))
        
        shape.addLine(to: CGPoint(x: 27, y: 52))
        shape.addLine(to: CGPoint(x: 22, y: 48))
        shape.addLine(to: CGPoint(x: 40, y: 20))
        
        
        shape.addLine(to: CGPoint(x: 50, y: 20))
        
        shape.close()
        
        return shape.cgPath
    }
}

class WeightOverlayLayer: CALayer {
    override func draw(in ctx: CGContext) {
        
        let WIDTH = frame.width
        
        ctx.setFillColor(UIColor.red.cgColor)
        
        ctx.fill(CGRect(x: (WIDTH / 2) , y: 4, width: 3, height: 50))
        ctx.fillEllipse(in: CGRect(x: (WIDTH / 2) - 5, y: 54, width: 12, height: 12))
        
    }
}

class WeightBackgroundLayer: CALayer {
    
    override func draw(in ctx: CGContext) {
        
        let WIDTH = frame.width
        
//        ctx.textMatrix = .identity
//        ctx.setCharacterSpacing(CGFloat(1))
//        ctx.setStrokeColor(UIColor.red.cgColor)
//        ctx.textPosition = CGPoint(x: (WIDTH / 2), y: 20)
//        ctx.setTextDrawingMode(.fill)
//        ctx.setFillColor(UIColor.blue.cgColor)
//
        
//        let attrs = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22)]
        
        for i in 0...99 {
            let tmpLineHeight = (i % 3 == 0) ? CGFloat(9) : CGFloat(6)
            
            ctx.fill(CGRect(x: (WIDTH / 2) , y: 6, width: 2, height: tmpLineHeight))
            
//            ("\(i)" as NSString).draw(at: CGPoint(x: 100, y: 100), withAttributes: attrs)
//            ("\(i)" as NSString).draw(in: CGRect(x: 100, y: 100, width: 10, height: 10), withAttributes: attrs)
            
            ctx.translateBy(x: (WIDTH / 2), y: (WIDTH / 2))
            ctx.rotate(by: CGFloat.pi / 49.5)
            ctx.translateBy(x: -(WIDTH / 2), y: -(WIDTH / 2))
        }
    }
}
