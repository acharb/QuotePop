//
//  CloudTableViewCell.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/15/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

class CloudTableViewCell: UITableViewCell {

    var currentCategory: Category?
    
    @IBOutlet weak var cloudImageView: UIImageView!
    
    @IBOutlet weak var cloudTitle: UITextField!
    
    @IBOutlet weak var xButton: UIImageView!
        
    func shakeCloud(_ counter: Int){
        var rotation = Double.pi/40
        if counter % 2 == 0 { rotation *= -1 }
        let wobble = CABasicAnimation(keyPath: "transform.rotation")
        wobble.duration = 0.15
        wobble.repeatCount = Float.infinity
        wobble.autoreverses = true
        wobble.fromValue = CGFloat(-rotation)
        wobble.toValue = CGFloat(rotation)
        self.cloudImageView.layer.add(wobble, forKey: "transform.rotation")
    }
    
    func stopCloud(){
        self.cloudImageView.layer.removeAllAnimations()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    

}
