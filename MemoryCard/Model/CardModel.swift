//
//  CardModel.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import Foundation

class CardModel { // елемент MVC
    
    /*
     Функція getCards повертає масив(типу Card) карток.
     Масив буде складатись з :
     - унікальних пар карток
     - картки будуть завжли розміщені в хаотичному порядку
     За допомогою циклу я вказую скільки ПАР карток мені потрібно створити :
     1) генерую рандомне число (число в межах від 1 до кількості фото, які знаходяться в assets)
     2) створюю першу картку(обєкт типу Card) з ПАРИ
     3) присвоюю картинку першій карточці за допомогою рандомного числа :
     - атрибуту "cardPhotoName" обєкта типу Card присвоюю стрічку з назвою фото
     4) додаю першу карточку в масив
     5) створюю другу картку(обєкт типу Card) з ПАРИ
     6) присвоюю ту саму картинку другій карточці за допомогою того самого рандомного числа
     7) додаю другу карточку в масив
     8) повторюємо виконання циклу з наступними парами карток
     */
    func getCards(cardNumberInModel: Int,imagePackInModel: String) -> [Card] {
        
        var cardArray = [Card]()
        
        // cardNumberInModel - кількість карток, яку я отримую з Picker'а
        // (cardNumberInModel!/2) - кількість пар карток
        
        for _ in 1...(cardNumberInModel/2) {
            
            // Створюю рандомне число (в межаж від 1 до 30) - це межі картинок з дефолтним стікерпаком "pockemons"
            let randomNumber = arc4random_uniform(30)+1
            
            // виводжу в консоль значення, для перевірки на унікальність кожної пари
            print("randomNumber = \(randomNumber)")
        
            switch imagePackInModel {
            case "Food":
                print("food")
                
                // Cтворюю 1 картку з пари
                let cardOne = Card()
                
                // Присвоюю картці назву фото(в межаж від 31 до 61),яка знаходиться в assets.
                cardOne.cardPhotoName = "\(randomNumber+30)"
                print("\(randomNumber)")
                
                // Додаю картку в масив
                cardArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.cardPhotoName = "\(randomNumber+30)"
                cardArray.append(cardTwo)
                
            case "Cars":
                
                let cardOne = Card()
                // Присвоюю картці назву фото(в межаж від 62 до 92),яка знаходиться в assets
                cardOne.cardPhotoName = "\(randomNumber+61)"
                cardArray.append(cardOne)
                
                let cardTwo = Card()
                cardTwo.cardPhotoName = "\(randomNumber+61)"
                cardArray.append(cardTwo)
                
            default:
                
                let cardOne = Card()
                // Присвоюю картці назву фото(в межаж від 1 до 30),яка знаходиться в assets.
                cardOne.cardPhotoName = "\(randomNumber)"
                cardArray.append(cardOne)
        
                let cardTwo = Card()
                cardTwo.cardPhotoName = "\(randomNumber)"
                cardArray.append(cardTwo)
            }
        }
        
        //MARK: Randoming cards in Array
        var randomArray = [Card]()
        // межа рандому == кількість карток
        var upperLimit:UInt = UInt(cardNumberInModel)
        var randomlyGeneratedNumber: Int
        
        // cardNumberInModel - кількість карток
        for _ in 1...(cardNumberInModel) {
            
            randomlyGeneratedNumber = Int(arc4random_uniform(UInt32(upperLimit)))
            randomArray.append(cardArray[randomlyGeneratedNumber])
            cardArray.remove(at: randomlyGeneratedNumber)
            upperLimit -= 1
        }
        // повертаю масив, в якому знаходяться картки
        return randomArray
    }
}

