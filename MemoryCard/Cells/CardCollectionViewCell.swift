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
    
    func setCard(_ card:Card) {
        DispatchQueue.global().async {
            self.card = card
            var imageUrlString = ""
            for image in imagesPic {
                if let name = image.name {
                    if card.cardPhotoName == name {
                        imageUrlString = image.link!
                    }
                }
            }
            let imageUrl = URL(string: imageUrlString)!
            DispatchQueue.global().async {
                self.photoCard.image = try! UIImage(withContentsOfUrl: imageUrl)
            }
        }
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
    
    func flip() {
        UIView.transition(from: self.backgroundCard, to: self.photoCard, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipback() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
            UIView.transition(from: self.photoCard, to: self.backgroundCard, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
    }
    
    func remove() {
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: {
            self.photoCard.alpha = 0
            self.backgroundCard.alpha = 0
        }, completion: nil)
    }
}

extension UIImage {
    
    convenience init?(withContentsOfUrl url: URL) throws {
        let imageData = try Data(contentsOf: url)
        self.init(data: imageData)
    }
}
