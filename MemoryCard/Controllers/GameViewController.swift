//
//  GameViewController.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    // Дефолтне значення кількості карток з MenuViewController
    var cardNumbersFromMenuController = 12
     // Дефолтне значення  назви стікерпаку з MenuViewController
    var imagePackLabelFromMenuController = "Pokemons"
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Викликаю метод з моделі картки, в масив cardArray заносимо картки
        cardArray = model.getCards(cardNumberInModel: cardNumbersFromMenuController,imagePackInModel: imagePackLabelFromMenuController )
        
        // Створюю таймер
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }

    // кнопка меню
    @IBOutlet weak var menuButton: UIButton!
    
    // таймер
    @IBOutlet weak var timerLabel: UILabel!
    
    var seconds = 0
    
    var timer: Timer?
    
    var timerIsOn = false
    
    // MARK: - Timer Methods
    
    @objc func timerElapsed() {
        // Додаємо 1 секунду
        seconds += 1
        // Заносимо значення в label
        timerLabel.text = "Time : \(seconds)"
    }
    
    // рахунок
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    // Екземпляр класу CardModel
    var model = CardModel()
    
    // Масив карток
    var cardArray = [Card]()
    
    // Індекс картки, яка була перевернутою перша
    var firstFlippedCardIndex:IndexPath?

    // MARK: - CollectionView Methods
    
    // Повертає розмір клітики залежно від кількості карток
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Ширина CollectionView
        let screenWidth = Int(cardCollectionView.frame.width)
        //  Висота CollectionView
        let screenHeight = Int(cardCollectionView.frame.height)
        
        //Задаємо розміри(ширину/висоту) клітинці
        var size = CGSize(width: screenWidth/3, height: screenHeight/6)
        
        // В залежності від кількості карток повертаю різні розміри клітинки
        switch cardNumbersFromMenuController {
        case 16:
            size = CGSize(width: screenWidth/4, height: screenHeight/4)
        case 18:
            size = CGSize(width: screenWidth/3, height: screenHeight/6)
        case 24:
            size = CGSize(width: screenWidth/4, height: screenHeight/6)
        case 28:
            size = CGSize(width: screenWidth/4, height: screenHeight/7)
        case 30:
            size = CGSize(width: screenWidth/5, height: screenHeight/6)
        case 32:
            size = CGSize(width: screenWidth/4, height: screenHeight/8)
        default:
            //  Дефолтне значення для 12 карток
           size = CGSize(width: screenWidth/3, height: screenHeight/4)
         }
        return size
    }
    
    // Повертає кількість клітинок
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    // Повертає створену клітинку
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // створюю клітинку
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        // створюю картку
        let card = cardArray[indexPath.row]
        // присвоюю клітинці цю картку
        cell.setCard(card)
        
        return cell
    }
    
    // Визначає клітинку, на яку нажато
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Виводить індекс клітинки на яку нажимаю
        print("IndexOf CardCell = \(indexPath.item)")
        
        // Клітинка, яку вибрав юзер
        let cell = cardCollectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Картка, яку вибрав юзер
        let card = cardArray[indexPath.row]
        
        // Якшо картка в дефолті + не виявлена
        if card.isFlipped == false && card.isMatched == false {
            
            // Перевертаю картку
            cell.flip()
            
            // Вказую шо картка перевернута
            card.isFlipped = true
            
            // Визначаю, яка картка перевернулась першою
            if firstFlippedCardIndex == nil {
                
                // перша картка, яка перевернулась
                firstFlippedCardIndex = indexPath
            } else {
                // друга картка яка перевернулась
                // викликаю метод з логікою виявлення карток
                checkForMatches(indexPath)
            }
        }
    }
    
    //MARK: Game Logic Methods
    
    // Перевіряє картки на однаковість
    func checkForMatches(_ secondFlippedCardIndex:IndexPath) {
        
        // створюю клітинки для двох карток які відкрив
        let cardOneCell = cardCollectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let cardTwoCell = cardCollectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // створюю картки для двох карток які відкрив
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Порівняння двох вибраних карт
        //  якшо дві картки однакові
        if cardOne.cardPhotoName == cardTwo.cardPhotoName {
            
            //cтатус двох карт
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // видаляю карточки які виявлені
            // виконується анімація видалення
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // затримка для виконання анімації
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                // деактивую тапання по клітинці
                // ? - якшо буде ніл то не крашниться програма
                cardOneCell?.removeFromSuperview()
                cardTwoCell?.removeFromSuperview()
            }
            // якщо картки різні
        } else {
            
            //TODO:!!!
           // flipCount += 1 // додаю невдалу спробу
            
            //статус двох карт
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //повертаю картки в дефолтний стан
            cardOneCell?.flipback()
            cardTwoCell?.flipback()
        }
        // перезавантажую клітинку першої картки якшо вона nil
        if cardOneCell == nil {
            cardCollectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        //  cкидує дані, шо перша картка перевернута
        firstFlippedCardIndex = nil
    }
}
