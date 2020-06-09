//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Rebecca Banks on 03/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card: Card) {
        // Keep track of the card the cell represents
        self.card = card
        
        // Set the front image view to the image that represents the card
        frontImageView.image = UIImage(named: card.imageName)
        
        if card.isMatched {
            frontImageView.alpha = 0
            backImageView.alpha = 0
            return
        }
        else {
            frontImageView.alpha = 1
            backImageView.alpha = 1
        }
        
        // Reset the state of the cell by checking the flip status of the card (flipped = front, !flipped = back)
        if card.isFlipped {
            // Show the front image view
            flipUp(speed: 0)
        }
        else {
            // Show the back image view
            flipDown(speed: 0, delay: 0)
        }
        
    }
    
    func flipUp(speed: TimeInterval = 0.3) { // Gives speed a default value of 0.3 seconds
        
        // Flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromLeft] , completion: nil)
        
        // Set the status of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed: TimeInterval = 0.3, delay: TimeInterval = 0.5) { // Gives speed a default value of 0.3 seconds
        
        // Delay the flip down to give user time to see the card
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) {
            
            // Flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews,.transitionFlipFromRight] , completion: nil)
        }
        
        // Set the status of the card
        card?.isFlipped = false
    }
    
    func remove() {
        
        // Make the image views invisible
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
            
        }, completion: nil)
    }
}
