//
//  QuoteModel.swift
//  QuotePop WatchKit Extension
//
//  Created by Alec Charbonneau on 3/27/18.
//  Copyright © 2018 Alec Charbonneau. All rights reserved.
//

import Foundation

import Foundation

class QuoteModel {
    
    
    var dictData: [String: [String]] {
        get{
            return [
                "motivationAuthors": motivationAuthors,
                "motivationQuotes": motivationQuotes,
                "wisdomAuthors": wisdomAuthors,
                "wisdomQuotes": wisdomQuotes,
                "relaxAuthors": relaxAuthors,
                "relaxQuotes": relaxQuotes
            ]
        }
        set(newValue) {
            motivationAuthors = newValue["motivationAuthors"]!
            motivationQuotes = newValue["motivationQuotes"]!
            wisdomAuthors = newValue["wisdomAuthors"]!
            wisdomQuotes = newValue["wisdomQuotes"]!
            relaxAuthors = newValue["relaxAuthors"]!
            relaxQuotes = newValue["relaxQuotes"]!
        }
    }
    
    var motivationAuthors: [String] = []
    var motivationQuotes: [String] = []
    
    var wisdomAuthors: [String] = []
    var wisdomQuotes: [String] = []
    
    var relaxAuthors: [String] = []
    var relaxQuotes: [String] = []
    
    
    
}
