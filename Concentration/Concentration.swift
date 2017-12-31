//
//  Concentration.swift
//  Concentration
//
//  Created by 李天培 on 2017/12/27.
//  Copyright © 2017年 lee. All rights reserved.
//

import Foundation

struct Concentration {
    // MARK: - public API
    private(set) var cards = [Card]()
    
    private(set) var mismatched = [Card : Bool]()
    
    private(set) var flipCount = 0
    
    private(set) var score = 0
    
    var isFinished : Bool {
        for card in cards {
            if !card.isMatched {
                return false
            }
        }
        return true
    }
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter({ cards[$0].isFaceUp }).oneAndOnly
//            var foundIndex: Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if foundIndex == nil {
//                        foundIndex = index
//                    } else {
//                        return nil
//                    }
//                }
//            }
//            return foundIndex
        }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "Concentration.chooseCard: index \(index) out of range.")
//        if cards[index].isFaceUp {
//            cards[index].isFaceUp = false
//        } else
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    score += 2
                } else {
                    score -= mismatched[cards[index]]! ? 1 : 0
                    score -= mismatched[cards[matchIndex]]! ? 1 : 0
                    mismatched[cards[index]] = true
                    mismatched[cards[matchIndex]] = true
                }
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                indexOfOneAndOnlyFaceUpCard = index
            }
            flipCount += 1
        }
    }
    
    mutating func newGame(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.newGame: numberOfPairsOfCards (\(numberOfPairsOfCards)) have some worry, it must have at least 1.")
        // clear game
        reset()
        // shuffle the cards
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards.insert(card, at: cards.count.arc4random)
            cards.insert(card, at: cards.count.arc4random)
            mismatched[card] = false
        }
        
    }
    
    mutating func reset() {
        cards.removeAll()
        mismatched.removeAll()
        flipCount = 0
        score = 0
    }
    
    init(numberOfPairsOfCards: Int) {
        newGame(numberOfPairsOfCards: numberOfPairsOfCards)
    }
}

extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
