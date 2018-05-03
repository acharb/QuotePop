//
//  QuotesCollectionViewCell.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 3/20/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit

@IBDesignable
class QuotesCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var cloudImage: UIImageView!
    @IBOutlet weak var authorTextField: UITextField!
    @IBOutlet weak var quoteTextView: UITextView!
    
    var currentQuoteObject: Quote?
    var indexPath: IndexPath?
    
}
