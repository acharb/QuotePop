//
//  ViewQuoteViewController.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 4/22/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit
import CoreData

protocol UpdateDeleteQuoteDelegate: class{
    func delete(quote: Quote, at location: IndexPath)
    func update(quote: Quote, toSay: String, at: IndexPath)
}

class ViewQuoteViewController: CustomBackgroundViewController, UITextViewDelegate {
    
    // MARK: UI data
    var quote: String?
    var author: String?
    var currentQuoteObject: Quote?
    
    //MARK: Core Data
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    lazy var context = container?.viewContext
    
    
    var previousVC: ViewController_CloudCollection?
    var indexPath: IndexPath?
    
    @IBOutlet weak var quoteTextView: UITextView!
    @IBAction func deleteButton(_ sender: Any) {
        if let currentQuoteObject = currentQuoteObject, let indexPath = indexPath{
            delegate?.delete(quote: currentQuoteObject, at: indexPath)
        }
        let _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func saveButton(_ sender: Any) {
        
        if quoteTextView.isFirstResponder { quoteTextView.resignFirstResponder() }
        
        if let currentQuoteObject = currentQuoteObject, let indexPath = indexPath{
            currentQuoteObject.author = author ?? "Anonymous"
            delegate?.update(quote: currentQuoteObject, toSay: quote!, at: indexPath)
            //(delegate as? ViewController_CloudCollection)?.collectionView.collectionViewLayout.invalidateLayout()
        }
        let _ = navigationController?.popViewController(animated: true)
    }
    
    // MARK: Load data
    
    weak var delegate: UpdateDeleteQuoteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quoteTextView.delegate = self
        quoteTextView.text = self.quote ?? ""
        
        
        let kbToolBar = UIToolbar()
        kbToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        kbToolBar.items = [doneButton]
        
        self.quoteTextView.inputAccessoryView = kbToolBar
    }

    // MARK: TextView Delegate
    @objc private func dismissKeyboard(){
        self.quoteTextView.resignFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.quote = quoteTextView.text
    }
}
