//
//  Connectivity.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 3/23/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import Foundation
import WatchConnectivity

class WatchManager: NSObject, WCSessionDelegate{
    var watchSession: WCSession?
    override init(){
        super.init()
        watchSession = WCSession.default
        watchSession?.delegate = self // for debugging
        watchSession?.activate()
    }
    //WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("session activation did complete")
    }
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("session did become inactive")
    }
    func sessionDidDeactivate(_ session: WCSession) {
        print("session did deactivate")
    }
    func sendData(_ data: [String: Any]){
        do {
            try self.watchSession?.updateApplicationContext(data)
        }catch{
            print("error sending data: \(data)")
        }
    }
    
    func sendDataAgressively(_ data: [String: Any]){
        self.watchSession?.sendMessage(data, replyHandler: nil, errorHandler: { (error) in
                print("error occured: \(error) ")
                return
                })
    }
}
