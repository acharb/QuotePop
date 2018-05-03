//
//  GlassesHead-ViewController.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/30/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

class GlassesHead_ViewController: UIViewController {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var leftGlasses: UIView!
    @IBOutlet weak var rightGlasses: UIView!
    @IBOutlet var clouds: [UIImageView]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let leftRadius = leftGlasses.bounds.width
        let rightRadius = rightGlasses.bounds.width
        leftGlasses.layer.cornerRadius = leftRadius / 2
        rightGlasses.layer.cornerRadius = rightRadius / 2
        leftGlasses.clipsToBounds = true
        rightGlasses.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        for cloud in clouds{
            cloud.center.x -= cloud.superview!.bounds.width
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        var duration = 6.5
        for cloud in clouds{
            let offset = leftGlasses.bounds.width
            UIView.animateKeyframes(withDuration: duration, delay: 0, options: [.repeat], animations: {
                cloud.center.x += offset * 2
                }, completion: { _ in
                    cloud.center.x -= offset
            })
            duration += 0.5
        }
    }
}
