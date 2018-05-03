//
//  GlassesHead-ViewController.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/28/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

class GlassesHead_ViewController_Programmatically: UIViewController {

    var headImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let viewFace = UIImageView(image: UIImage(named: "glasses-face-cloudless"))
        headImageView = viewFace
        view.addSubview(headImageView)
        headImageView.translatesAutoresizingMaskIntoConstraints = false
        let margin = view.layoutMarginsGuide
        
        headImageView.heightAnchor.constraint(equalTo: margin.heightAnchor, multiplier: 0.5).isActive = true
        headImageView.widthAnchor.constraint(equalTo: headImageView.heightAnchor, multiplier: 1.05).isActive = true
        headImageView.bottomAnchor.constraint(equalTo: margin.bottomAnchor,constant: -10.0).isActive = true
        headImageView.centerXAnchor.constraint(equalTo: margin.centerXAnchor).isActive = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let xOffset1 = headImageView.bounds.width/3.7
        let yOffset1 = headImageView.bounds.height/3.8
        let xOffset2 = headImageView.bounds.width/5.5
        let yOffset2 = headImageView.bounds.height/4.5
        let xOffset3 = headImageView.bounds.width/6.5
        let yOffset3 = headImageView.bounds.height/2.8
        //left side
        layoutCloud(xOffset: xOffset1 + 8.0, yOffset: yOffset1, sizeRatio: 0.05, hWRatio: 0.6,
                    rightFirst: false, displacement: 5.0, speed: 2.5, leftSide: true)
        layoutCloud(xOffset: xOffset2, yOffset: yOffset2, sizeRatio: 0.07, hWRatio: 0.6,
                    rightFirst: true, displacement: 5.0, speed: 2.0, leftSide: true)
        layoutCloud(xOffset: xOffset3, yOffset: yOffset3 - 5.0, sizeRatio: 0.07, hWRatio: 0.7,
                    rightFirst: false, displacement: 5.0, speed: 2.3, leftSide: true)

        //right side
        layoutCloud(xOffset: -xOffset1, yOffset: yOffset1 + 10.0, sizeRatio: 0.06, hWRatio: 0.6,
                    rightFirst: false, displacement: 5.0, speed: 2.3, leftSide: false)
        layoutCloud(xOffset: -xOffset2, yOffset: yOffset2, sizeRatio: 0.07, hWRatio: 0.7,
                    rightFirst: true, displacement: 5.0, speed: 2.0, leftSide: false)
        layoutCloud(xOffset: -xOffset3, yOffset: yOffset3, sizeRatio: 0.07, hWRatio: 0.5,
                    rightFirst: true, displacement: 5.0, speed: 2.5, leftSide: false)

        
        layoutThoughtCloud()
    }
    
    private func layoutThoughtCloud(){
        
        let thought = UIImageView(image: UIImage(named: "cloud-default"))
        headImageView.addSubview(thought)
        thought.translatesAutoresizingMaskIntoConstraints = false
        thought.bottomAnchor.constraint(equalTo: headImageView.topAnchor, constant: -10.0).isActive = true
        thought.trailingAnchor.constraint(equalTo: headImageView.trailingAnchor, constant: -10.0).isActive = true
        thought.heightAnchor.constraint(equalTo: headImageView.heightAnchor, multiplier: 0.15).isActive = true
        thought.widthAnchor.constraint(equalTo: thought.heightAnchor, multiplier: 1.5).isActive = true
        
        let thought2 = UIImageView(image: UIImage(named: "cloud-default"))
        headImageView.addSubview(thought2)
        thought2.translatesAutoresizingMaskIntoConstraints = false
        thought2.bottomAnchor.constraint(equalTo: headImageView.topAnchor, constant: -30.0).isActive = true
        thought2.trailingAnchor.constraint(equalTo: headImageView.trailingAnchor, constant: 0.0).isActive = true
        thought2.heightAnchor.constraint(equalTo: headImageView.heightAnchor, multiplier: 0.2).isActive = true
        thought2.widthAnchor.constraint(equalTo: thought.heightAnchor, multiplier: 2.5).isActive = true
        
        
    }
    
    private func layoutCloud(xOffset: CGFloat,yOffset: CGFloat, sizeRatio: CGFloat, hWRatio: CGFloat, rightFirst: Bool, displacement:CGFloat, speed: Double,leftSide: Bool){
        let cloud = UIImageView(image: UIImage(named: "cloud-default"))
        cloud.translatesAutoresizingMaskIntoConstraints = false
        if let headImageView = headImageView {
            headImageView.addSubview(cloud)
            if leftSide {
                cloud.leadingAnchor.constraint(equalTo: headImageView.leadingAnchor,constant: xOffset).isActive = true
                cloud.topAnchor.constraint(equalTo: headImageView.topAnchor,constant: yOffset).isActive = true
                cloud.heightAnchor.constraint(equalTo: cloud.widthAnchor, multiplier: hWRatio).isActive = true
                cloud.heightAnchor.constraint(equalTo: headImageView.heightAnchor, multiplier: sizeRatio).isActive = true
                
                UIView.animate(withDuration: speed, delay: 0, options: [.repeat,.autoreverse], animations: {
                    cloud.center.y = cloud.center.y + (rightFirst ? displacement:-displacement)
                }, completion: { check in
                    cloud.removeFromSuperview()
                })
            }else {
                cloud.trailingAnchor.constraint(equalTo: headImageView.trailingAnchor,constant: xOffset).isActive = true
                cloud.topAnchor.constraint(equalTo: headImageView.topAnchor,constant: yOffset).isActive = true
                cloud.heightAnchor.constraint(equalTo: cloud.widthAnchor, multiplier: hWRatio).isActive = true
                cloud.heightAnchor.constraint(equalTo: headImageView.heightAnchor, multiplier: sizeRatio).isActive = true
                
                UIView.animate(withDuration: speed, delay: 0, options: [.repeat,.autoreverse], animations: {
                    cloud.center.y = cloud.center.y + (rightFirst ? -displacement:displacement)
                }, completion: { check in
                    cloud.removeFromSuperview()
                })
            }
        }
    }
}







