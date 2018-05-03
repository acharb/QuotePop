//
//  InterfaceController.swift
//  QuotePop WatchKit Extension
//
//  Created by Alec Charbonneau on 3/19/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    
    //MARK : category changes
    
    @IBAction func nextButton() {
        self.currentCount += 1
        if currentCategory == "Wisdom" {setWisdom()}
        else if currentCategory == "Motivation" { setMotivation() }
        else if currentCategory == "Relax" { setRelaxation() }
    }
    
    private func setMotivation(){
        if currentCount >= self.quoteModel.motivationQuotes.count { currentCount = 0 }
        if self.quoteModel.motivationQuotes.count == 0 {self.quoteLabel.setText("no quote here!")}
        else{
            self.quoteLabel.setText(self.quoteModel.motivationQuotes[currentCount])
            self.authorLabel.setText("-"+self.quoteModel.motivationAuthors[currentCount])
        }
    }
    private func setWisdom(){
        if currentCount >= self.quoteModel.wisdomQuotes.count { currentCount = 0 }
        
        if self.quoteModel.wisdomQuotes.count == 0 {self.quoteLabel.setText("no quote here!")}
        else {
            self.quoteLabel.setText(self.quoteModel.wisdomQuotes[currentCount])
            self.authorLabel.setText("-"+self.quoteModel.wisdomAuthors[currentCount])
        }
    }
    private func setRelaxation(){
        if currentCount >= self.quoteModel.relaxQuotes.count { currentCount = 0 }
        
        if self.quoteModel.relaxQuotes.count == 0 {self.quoteLabel.setText("no quote here!")}
        else{
            self.quoteLabel.setText(self.quoteModel.relaxQuotes[currentCount])
            self.authorLabel.setText("-"+self.quoteModel.relaxAuthors[currentCount])
        }
    }
    
    
    // MARK: Context Menu buttons
    
    @IBAction func Relax() {
        self.currentCategory = "Relax"
        setRelaxation()
    }
    @IBAction func Motivate() {
        self.currentCategory = "Motivation"
        setMotivation()
    }
    @IBAction func BeWise() {
        self.currentCategory = "Wisdom"
        setWisdom()
    }
    
    // MARK: Data
    

    var quoteModel = QuoteModel()
    var currentCategory = "Wisdom"
    var currentCount = 0
    
    @IBOutlet var authorLabel: WKInterfaceLabel!
    @IBOutlet var quoteLabel: WKInterfaceLabel! 
    
    // MARK: Watch Connectivity
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session activation did complete")
    }
    
    // for testing, called when application context updated
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("session did receive appllication context: \(applicationContext) ")
        
        if let context = applicationContext as? [String: [String]]{
            self.quoteModel.dictData = context
        }
        
        self.quoteLabel.setText(quoteModel.wisdomQuotes[0])
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let context = message as? [String: [String]]{
            self.quoteModel.dictData = context
        }
        
        self.quoteLabel.setText(quoteModel.wisdomQuotes[0])
    }
    
    
    var watchSession: WCSession? {
        didSet{
            if let session = watchSession {
                session.delegate = self
                session.activate()
            }
        }
    }
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        watchSession = WCSession.default
        
        
        
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
