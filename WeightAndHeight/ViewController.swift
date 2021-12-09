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
