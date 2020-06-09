//
//  ViewController.swift
//  MatchApp
//
//  Created by Rebecca Banks on 03/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    let model = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Int = 30 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        
        // Set the view controller as the datasource and the delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Initialise the timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Play shuffle sound
        soundPlayer.playSound(effect: .shuffle)
    }
    
    // MARK: - Timer Methods
    
    @objc func timerFired() {
        
        // Decrement the counter
        milliseconds -= 1
        
        // Update the label
        let seconds:Double = Double(milliseconds) / 1000.0
        timerLabel.text = String(format: "Time Remaining: %.2f", seconds)
        
        // Stop the timer if it reaches zero
        if milliseconds == 0 {
            
            timerLabel.textColor = UIColor.red
            timer?.invalidate()
            
            // Check if the user has cleared all of the pairs
            checkForGameEnd()
        }
    }
    
    // MARK: - Collection View Delegate Methods
    
    // Gets the numver of items needed for the collection view
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return number of cards
        return cardsArray.count
    }
    
    // Creates a cell for a particular index
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get a cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Return it
        return cell
    }
    
    // Fixes problem where if cell was out of view, it wouldnt flip it back over
    // Called just before the cell is displayed and gives you oppotunity to modify/configure the cell
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // Configure the state of the cell based on the properties of the card it represents
        
        let cardCell = cell as? CardCollectionViewCell
        
        // Get the card from the card array
        let card = cardsArray[indexPath.row]
        
        // Finish configuring the cell
        cardCell?.configureCell(card: card)
    }
    
    // When a card is tapped
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there is any time remaining, don't let the user interact
        if milliseconds <= 0 {
            return
        }
        
        // Get a reference to the cell that was tapped
        let cell = collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // Check the status of the card to determine how to flip it
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false {
            
            // Flip the card up
            cell?.flipUp()
            
            // Play sound
            soundPlayer.playSound(effect: .flip)
            
            // Check if this is the first flipped card
            if firstFlippedCardIndex == nil {
                
                // This is the first card flipped over
                firstFlippedCardIndex = indexPath
            }
            else {
                // This is the second card that is flipped
                
                // Run comparison logic
                checkForMatch(indexPath)
            }
        }
    }
    
    // MARK: - Game logic Methods
    
    func checkForMatch(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the two card objects for the two indice and see if they match
        let card1 = cardsArray[firstFlippedCardIndex!.row]
        let card2 = cardsArray[secondFlippedCardIndex.row]
        
        // Get the two collection view cells that represents the card
        let card1Cell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let card2Cell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        if card1.imageName == card2.imageName {
            // It's a match!!
            
            // Play match sound
            soundPlayer.playSound(effect: .match)
            
            // Set the status
            card1.isMatched = true
            card2.isMatched = true
            
            // Remove them
            card1Cell?.remove()
            card2Cell?.remove()
            
            // Was that the last pair?
            checkForGameEnd()
            
        }
        else {
            
            // Is not a match
            
            // Play sound
            soundPlayer.playSound(effect: .nomatch)
            
            card1.isFlipped = false
            card2.isFlipped = false
            
            // Flip them back over
            card1Cell?.flipDown()
            card2Cell?.flipDown()
            
        }
        
        // Reset the firstFlippedCardIndex property
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd() {
        
        // Check if theres any card that is unmatched
        // Assume user had won, loop through all cards to see if one is unmatched
        var hasWon = true
        
        for card in cardsArray {
            
            if !card.isMatched {
                // Found an unmatched card
                hasWon = false
                break
            }
        }
        
        if hasWon {
            
            // User has won, show an alert
            showAlert(title: "Congratulations!", message: "You have won the game!")
            
        }
        else {
            
            // User has not won yet, check if theres any time left
            if milliseconds <= 0 {
                showAlert(title: "Time's Up", message: "Sorry, better luck next time!")
            }
            
        }
        
    }
    
    func showAlert(title:String, message:String){
        
        // Create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button for the user to dimiss it
        let okayAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okayAction)
        
        // Show the alert
        present(alert, animated: true, completion: nil)
    }

}

