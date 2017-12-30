//
//  Card.swift
//  Concentration
//
//  Created by 李天培 on 2017/12/27.
//  Copyright © 2017年 lee. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return identifier }
    
    var isFaceUp = false
    var isMatched = false
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier()
    }
    
    static func == (left: Card, right: Card) -> Bool {
        return left.identifier == right.identifier
    }
}
