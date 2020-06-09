//
//  CardModel.swift
//  MatchApp
//
//  Created by Rebecca Banks on 03/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import Foundation

class CardModel {
    func getCards() -> [Card]{
        // Declare an empty array
        var generatedCards = [Card]()
        
        
        var numbers = Array(repeating: false, count: 13)
        
        // Randomly generate 8 pairs of cards
        while generatedCards.count < 16 {
            // Generate a random number
            let randomNumber = Int.random(in: 1...13)
            if  !numbers[randomNumber - 1] {
                // Create two a new card object
                let card1 = Card()
                let card2 = Card()
                
                // Set image names
                card1.imageName = "card\(randomNumber)"
                card2.imageName = "card\(randomNumber)"
                
                // Add to array
                generatedCards += [card1, card2]
                
                numbers[randomNumber - 1] = true
            }
        }
        
        // Randomise the cards within the array
        generatedCards.shuffle()
        
        // Return array
        return generatedCards
    }
}
