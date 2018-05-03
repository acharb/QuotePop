//
//  AddNewQuote_ViewController.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 3/21/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import UIKit


protocol AddQuoteDelegate: class {
    func addNewQuote(quote: String, by author: String)
}

class AddNewQuote_ViewController: CustomBackgroundViewController, UITextViewDelegate, UITextFieldDelegate {

    weak var delegate: AddQuoteDelegate?
    
    @IBOutlet weak var quote: UITextView!
    
    @IBOutlet weak var author: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.quote.delegate = self
        self.author.delegate = self
        // Do any additional setup after loading the view.
        
        let kbToolBar = UIToolbar()
        kbToolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        kbToolBar.items = [doneButton]
        
        self.quote.inputAccessoryView = kbToolBar
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        //dismiss(animated: true, completion: nil)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        var authorString = author.text!
        if authorString == "" {authorString = "Anonymous"}
        delegate?.addNewQuote(quote: quote.text, by: authorString)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    lazy var pvc = presentingViewController!
    
    
    // MARK: TextView Delegate Methods
    
    @objc func dismissKeyboard(_ sender: Any?){
        self.quote.resignFirstResponder()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = nil
        textView.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    // MARK Notification Center methods
    
    @objc func keyboardWillShow(notification: Notification){
        adjustingHeight(show:true, notification: notification)
    }
    
    @objc func keyboardWillHide(notification: Notification){
        adjustingHeight(show:false, notification: notification)
    }
    
    func adjustingHeight(show: Bool, notification: Notification){
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue) as! CGRect
        let animationDuration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval
        let changeInHeight = (keyboardFrame.height + 40) * (show ? 1 : -1)
        UIView.animate(withDuration: animationDuration) {
            self.author.center.y -= changeInHeight
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        author.resignFirstResponder()
    }
    
}











