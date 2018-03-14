//
//  CardModel.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import Foundation

class CardModel {
    
    func getCards(cardNumberInModel: Int,imagePackInModel: String) -> [Card] {
        
        var cardArray = [Card]()
        
        for _ in 1...(cardNumberInModel/2) {
            
            let randomNumber = arc4random_uniform(30)+1
            
            switch imagePackInModel {
            case "Food":
                let cardOne = Card()
                cardOne.cardPhotoName = "\(randomNumber+30)"
                cardArray.append(cardOne)
                let cardTwo = Card()
                cardTwo.cardPhotoName = "\(randomNumber+30)"
                cardArray.append(cardTwo)
                
            case "Cars":
                let cardOne = Card()
                cardOne.cardPhotoName = "\(randomNumber+61)"
                cardArray.append(cardOne)
                let cardTwo = Card()
                cardTwo.cardPhotoName = "\(randomNumber+61)"
                cardArray.append(cardTwo)
                
            default:
                let cardOne = Card()
                cardOne.cardPhotoName = "\(randomNumber)"
                cardArray.append(cardOne)
                let cardTwo = Card()
                cardTwo.cardPhotoName = "\(randomNumber)"
                cardArray.append(cardTwo)
            }
        }
        
        //MARK: Randoming cards in Array
        
        var randomArray = [Card]()
        var upperLimit:UInt = UInt(cardNumberInModel)
        var randomlyGeneratedNumber: Int
        
        for _ in 1...(cardNumberInModel) {
            randomlyGeneratedNumber = Int(arc4random_uniform(UInt32(upperLimit)))
            randomArray.append(cardArray[randomlyGeneratedNumber])
            cardArray.remove(at: randomlyGeneratedNumber)
            upperLimit -= 1
        }
        return randomArray
    }
}

