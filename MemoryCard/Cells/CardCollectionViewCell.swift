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
    
    // визначає, яку карточку має вивести cell
    func setCard(_ card:Card){
        
        self.card = card
        
        // Якщо картка виявлена, роблю фото невидимими
        if card.isMatched == true {
            
            backgroundCard.alpha = 0
            photoCard.alpha = 0
            
            return
            // якщо картка не виявлена, роблю фото видимими
        } else {
            
            backgroundCard.alpha = 1
            photoCard.alpha = 1
        }
        photoCard.image = UIImage(named: card.cardPhotoName)
        
        //перевіряю картку на її стан (перевернута / неперевернута)
        if card.isFlipped == true {
            //переконуюсь що картинка зверху
            UIView.transition(from: backgroundCard, to: photoCard, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            //переконуюсь що картинка знизу
        } else {
            UIView.transition(from: photoCard, to: backgroundCard, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
        }
    }
    // Виконує перевертання  з дефолту на картку з фото
    func flip() {
        
        //затримка виконання
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            //анімація
            UIView.transition(from: self.backgroundCard, to: self.photoCard, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil) //  duration - час переходу
        }
    }
    
    // Виконує перевертання в дефолтний стан
    func flipback() {
        
        // затримка виконання
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.6) {
            //анімація
            UIView.transition(from: self.photoCard, to: self.backgroundCard, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil) // duration - час переходу
        }
    }
    
    // Виконує деактивування видимості зображень на картці
    func remove() {
        
        // анімація
        UIView.animate(withDuration: 0.5, delay: 0.5, options: .curveEaseOut, animations: { // використовую closure
            
            self.photoCard.alpha = 0
            self.backgroundCard.alpha = 0
            
        }, completion: nil)
    }
}
