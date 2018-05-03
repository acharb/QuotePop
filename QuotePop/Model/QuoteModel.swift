//
//  QuoteModel.swift
//  QuotePop
//
//  Created by Alec Charbonneau on 3/19/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import Foundation

class QuoteModel {
    

    // needs to be able to
    //1. return author and quote for 4 different categories
    //2. be able to change when categories change
    
    func getOrder() -> [String]{
        return [
            authors0[0],
            authors1[0],
            authors2[0],
            authors3[0]
        ]
    }
    
    
    func moveData(source:Int,destination:Int){
        var authors = [String]()
        var quotes = [String]()
        switch source{
        case 0:
            authors = authors0
            quotes = quotes0
        case 1:
            authors = authors1
            quotes = quotes1
        case 2:
            authors = authors2
            quotes = quotes2
        case 3:
            authors = authors3
            quotes = quotes3
        default: break
        }
        
        if source > destination { // source below destination
            shiftDown(from: destination, to: source)
        } else {
            shiftUp(from: destination, to: source)
        }
            switch destination{
            case 0:
                authors0 = authors
                quotes0 = quotes
            case 1:
                authors1 = authors
                quotes1 = quotes
            case 2:
                authors2 = authors
                quotes2 = quotes
            case 3:
                authors3 = authors
                quotes3 = quotes
            default:
                break
            }
    }
    
    func getAuthors(identity: Int) -> [String]{
        switch identity{
            case 0: return authors0
            case 1: return authors1
            case 2: return authors2
            case 3: return authors3
            default: return []
        }
    }
    
    func getQuotes(identity: Int) -> [String]{
        switch identity{
            case 0: return quotes0
            case 1: return quotes1
            case 2: return quotes2
            case 3: return quotes3
            default: return []
        }
    }
    
    func shiftUp(from identity:Int, to marker:Int){
        switch marker{
        case 0:
            if identity >= 1 { // from 1 to 0
                self.authors0 = self.authors1
                self.quotes0 = self.quotes1
            }
            if identity >= 2{ // from 2 to 0
                self.authors1 = self.authors2
                self.quotes1 = self.quotes2
            }
            if identity == 3{ // from 3 to 0
                self.authors2 = self.authors3
                self.quotes2 = self.quotes3
                //replace 3
                self.authors3 = [String]()
                self.quotes3 = [String]()
            }
        case 1:
            if identity >= 2 { //from 2 to 1
                self.authors1 = self.authors2
                self.quotes1 = self.quotes2
            }
            if identity == 3 { //from 3 to 1
                self.authors2 = self.authors3
                self.quotes2 = self.quotes3
                //replace 3
                self.authors3 = [String]()
                self.quotes3 = [String]()
            }
        case 2:
            if identity == 3 { // from 3 to 2
                self.authors2 = self.authors3
                self.quotes2 = self.quotes3
                self.authors3 = [String]()
                self.quotes3 = [String]()
            }
        case 3:
            self.authors3 = [String]()
            self.quotes3 = [String]()
        default: break
        }
    }
    
    
    
    func shiftDown(from identity:Int, to marker: Int){
        switch identity{
        case 0:
            if marker >= 1 {
                self.quotes1 = self.quotes0
                self.authors1 = self.authors0
            }
            if marker >= 2 {
                self.quotes2 = self.quotes1
                self.authors2 = self.authors1
            }
            if marker == 3 {
                self.quotes3 = self.quotes2
                self.authors3 = self.authors2
            }
            self.quotes0 = [String]()
            self.authors0 = [String]()
        case 1:
            if marker >= 2 {
                self.quotes2 = self.quotes1
                self.authors2 = self.authors1
            }
            if marker == 3 {
                self.quotes3 = self.quotes2
                self.authors3 = self.authors2
            }
            self.quotes1 = [String]()
            self.authors1 = [String]()
        case 2:
            if marker == 3 {
                self.quotes3 = self.quotes2
                self.authors3 = self.authors2
            }
            self.quotes2 = [String]()
            self.authors2 = [String]()
        case 3:
            self.quotes3 = [String]()
            self.authors3 = [String]()
        default: break
        }
    }
    
    private var authors0: [String] = ["first"]
    private var quotes0: [String] = ["test"]
    
    private var authors1: [String] = ["second","Teddy Roosevelt", "Drake","Teddy","Teddy Rose"]
    private var quotes1: [String] = ["test","It is not the critic who counts; not the man who points out how the strong man stumbles, or where the doer of deeds could have done them better. The credit belongs to the man who is actually in the arena, whose face is marred by dust and sweat and blood; who strives valiantly; who errs, who comes short again and again, because there is no effort without error and shortcoming; but who does actually strive to do the deeds; who knows great enthusiasms, the great devotions; who spends himself in a worthy cause; who at the best knows in the end the triumph of high achievement, and who at the worst, if he fails, at least fails while daring greatly, so that his place shall never be with those cold and timid souls who neither know victory nor defeat.",
                                  "started",
                                  "It is not the critic who counts; not the man who points out how the strong man stumbles, or where the doer of deeds could have done them better. The credit belongs to the man who is actually in the arena, whose face is marred by dust and sweat and blood; who strives valiantly; who errs, who comes short again and again",
                                  "It is not the critic who counts; not the man who points out how the strong man stumbles"]
    
    private var authors2: [String] = ["third","Alec", "Bob Marley"]
    private var quotes2: [String] = ["test","I am awesome","Just relax bro"]
    private var authors3: [String] = ["fourth","Alec", "Johnn"]
    private var quotes3: [String] = ["test","Hello how are we","yo"]

    


}
