//
//  ViewController.swift
//  Concentration
//
//  Created by 李天培 on 2017/12/26.
//  Copyright © 2017年 lee. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {
    // MARK: - Contants
    private let emojiTheme = [
        Theme(name  : "sports",
              emoji : ["⚽️","🏀","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸","🏒","🏑","🏏","🏹","🥊","⛸","🥋","🎣"],
              cardBackColor : #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1),
              backgroundColor : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),
        Theme(name  : "animals",
            emoji : ["🐶","🐱","🐭","🐹","🐰","🦊","🐻","🐼","🐨",
                     "🐯","🦁","🐮","🐵","🐸","🐽","🐷","🐔","🐧"],
            cardBackColor : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1),
            backgroundColor : #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)),
        Theme(name  : "fruits",
            emoji : ["🍎","🍐","🍊","🍋","🍌","🍉","🍇","🍓","🍈",
                     "🍒","🍑","🍍","🥥","🥝","🍅","🍆","🥑","🥦"],
            cardBackColor : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),
            backgroundColor : #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)),
        Theme(name  : "flags",
            emoji : ["🏳️‍🌈","🇩🇿","🇦🇫","🇴🇲","🇦🇼","🇦🇪","🇦🇷","🇦🇿","🇪🇬",
                     "🇪🇹","🇮🇪","🇦🇮","🇦🇴","🇦🇩","🇪🇪","🇦🇬","🇦🇹","🇦🇽",
                     "🇧🇸","🇵🇬","🇧🇧","🇲🇴","🇵🇰","🇵🇾","🇵🇸","🇧🇭"],
            cardBackColor : #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1),
            backgroundColor : #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)),
        Theme(name  : "foods",
            emoji : ["🥐","🍞","🥖","🥨","🧀","🥚","🥓","🥩","🍗",
                     "🍖","🌭","🍔","🍟","🍕","🥪","🥙","🌮","🥫"],
            cardBackColor : #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1),
            backgroundColor : #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)),
        Theme(name  : "clothes",
            emoji : ["👚","👕","👖","👔","👗","👙","👘","👠","👡",
                     "👢","👞","👟","🎩","🧣","🧤","🧦","🧢","👒"],
            cardBackColor : #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1),
            backgroundColor : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1))
    ]
    
    // MARK: - Variables
    private var flipCount: Int {
        get { return game.flipCount }
        set { flipCountLabel.text = "Flips: \(game.flipCount)" }
    }
    private var score: Int {
        get { return game.score }
        set { scoreLabel.text = "Score: \(score)" }
    }
    
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    
    private var emoji = [Card: String]()
    
    private lazy var theme = emojiTheme[emojiTheme.count.arc4random]
    
    private var isGaming = false {
        didSet {
            // TODO: change Time
            if isGaming {
                
            } else {
                
            }
        }
    }
    
    // MARK: Computed
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    // MARK: Outlets
    @IBOutlet private weak var flipCountLabel: UILabel!
    @IBOutlet private var cardButtons: [UIButton]!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    
    // MARK: - Actions
    
    @IBAction private func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateUI()
        }
        // start game
        if !isGaming {
            isGaming = true
        }
    }
    @IBAction func newGame() {
        let randomTheme = emojiTheme[emojiTheme.count.arc4random]
        theme = randomTheme
        game.newGame(numberOfPairsOfCards: cardButtons.count)
        view.backgroundColor = theme.backgroundColor
        isGaming = false
        updateUI()
    }
    // MARK: Methods
    
    private func updateUI() {
        if game.isFinished {
            isGaming = false
        }
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            button.isEnabled = true
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                button.isEnabled = false
            } else {
                if card.isMatched {
                    button.isEnabled = false
                } else {
                    button.setTitle("", for: .normal)
                    button.backgroundColor = theme.cardBackColor
                }
                button.isEnabled = true
            }
        }
        flipCount = game.flipCount
        score = game.score
    }
    
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil && theme.emoji.count > 0 {
            let randomIndex = theme.emoji.count.arc4random
            emoji[card] = theme.emoji.remove(at: randomIndex)
        }
        return emoji[card] ?? "?"
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        newGame()
    }
}

struct Theme {
    let name: String
    var emoji: [String]
    let cardBackColor: UIColor // = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    let backgroundColor: UIColor //= #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

extension Int {
    var arc4random: Int {
        switch self {
        case let number where number > 0:
            return +Int(arc4random_uniform(UInt32(+self)))
        case let number where number < 0:
            return -Int(arc4random_uniform(UInt32(-self)))
        default:
            return 0
        }
    }
}

