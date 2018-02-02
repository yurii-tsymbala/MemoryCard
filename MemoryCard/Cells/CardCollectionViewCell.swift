//
//  CardCollectionViewCell.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoCard: UIImageView!
    
    @IBOutlet weak var backgroundCard: UIImageView!
    
    var card:Card?
    
    // Sets image in the card
    func setCard(_ card:Card){
        
        self.card = card
        // "card.cardPhotoName" name of the image in assets
        photoCard.image = UIImage(named: card.cardPhotoName)
    
    //Fixed bugs with viewing cards after restart of the level
        
        if card.isMatched == true {
            backgroundCard.alpha = 0
            photoCard.alpha = 0
            return
        } else {
            backgroundCard.alpha = 1
            photoCard.alpha = 1
        }
        
        if card.isFlipped == true {
            UIView.transition(from: backgroundCard, to: photoCard, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        } else {
            UIView.transition(from: photoCard, to: backgroundCard, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    
    // MARK: - CardCell methods
    
    // Flips  from default to card with image
    func flip() {
            UIView.transition(from: self.backgroundCard, to: self.photoCard, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    // Returns to the default status
    func flipback() {
        // Delay for memorization pairs of opened cards
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            UIView.transition(from: self.photoCard, to: self.backgroundCard, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    // Removes visibility of images on card
    func remove() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            // using closure
            self.photoCard.alpha = 0
            self.backgroundCard.alpha = 0
        }, completion: nil)
    }
}
