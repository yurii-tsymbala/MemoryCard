//
//  GameViewController.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    override func viewDidLoad() {
        
        // викликаємо функцію яка відповідає за передачу карток з моделі
        newGame()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "retryButton"), object: nil, queue: OperationQueue.main)
        { (notification) in
            
            self.newGame()
        }
        
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    // Дефолтне значення кількості карток з MenuViewController
    var cardNumbersFromMenuController = 12
    // Дефолтне значення  назви стікерпаку з MenuViewController
    var imagePackLabelFromMenuController = "Pokemons"

    // обнуляє результати гри
    func newGame(){
        
        // Викликаю метод з моделі картки, в масив cardArray заносимо картки
        cardArray = model.getCards(cardNumberInModel: cardNumbersFromMenuController,imagePackInModel: imagePackLabelFromMenuController )
        
        // обнуляю час
        seconds = 0
        timerLabel.text = "Time : \(seconds)"
        //обнуляю кількість спроб
        flipCount = 0
        flipCountLabel.text = "Tries : \(flipCount)"
        // обновляю вюшку
        cardCollectionView.reloadData()
    }
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    // кнопка меню
    @IBAction func menuButton(_ sender: UIButton) {
        // зупиняє таймер
        timer?.invalidate()
    }
    
    // таймер
    @IBOutlet weak var timerLabel: UILabel!
    
    var seconds = 0
    
    var timer: Timer?
    
    // MARK: - Timer Methods
    
    func timerStart(){
        
        //Create timer
        if !(timer?.isValid ?? false) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerElapsed() {
        // Додаємо 1 секунду
        seconds += 1
        // Заносимо значення часу в label
        timerLabel.text = "Time : \(seconds)"
    }
    
    // рахунок
    @IBOutlet weak var flipCountLabel: UILabel!
    
    // Лічильник кількості невдалих спроб
    var flipCount = 0 {
        didSet {
            // буду рахувати кількість невдалих спроб
            //заносимо значення в flipCountLabel
            flipCountLabel.text = "Tries : \(flipCount)"
        }
    }
    
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
        case 10:
            size = CGSize(width: screenWidth/2, height: screenHeight/5)
        case 12:
            size = CGSize(width: screenWidth/3, height: screenHeight/4)
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
        case 36:
            size = CGSize(width: screenWidth/6, height: screenHeight/6)
        default:
            //  Дефолтне значення для 8 карток
            size = CGSize(width: screenWidth/2, height: screenHeight/4)
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
        
        //Дизайн клітинок
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        })
        // cell.layer.cornerRadius = 15
        // cell.layer.borderWidth = 2
        
        return cell
    }
    
    // Визначає клітинку, на яку нажато
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Запускаю таймер
        timerStart()
        
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
                
                // перевіряю чи залишились невідкриті картки в грі
                self.checkGameEnded()
            }
            // якщо картки різні
        } else {
            
            flipCount += 1 // додаю невдалу спробу
            
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
    
    // Перевіряє чи залишились картки в грі
    func checkGameEnded(){
        
        var isWon = true
        
        // Перевіряю чи залишились невиявлевні картки - проходжу кожну карточку через масив
        for card in cardArray {
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        
        //Якщо не залишилось карток - зупиняю таймер + викликаю попапвю
        if isWon == true {
            timer?.invalidate()
            
            //  переходжу на рекордменю
            performSegue(withIdentifier: "RecordSegue", sender: self)
        }
    }
    
    // Надсилає дані (час і кількість спроб ) в PopUpViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "RecordSegue" {
            
            
            let cardsNumberFromLevel = segue.destination as! PopUpViewController
            // отримую кількість карток з меню контролера
            cardsNumberFromLevel.cardsNumberFromGameController = cardNumbersFromMenuController
            
            // Кількість карток буде братись з клітинки Левелів LevelPackCell
            let timeFromLevel = segue.destination as! PopUpViewController
            timeFromLevel.timeFromGameController = seconds
            
            // Назва стікерпаку буде братись з клітинки ImagePackCell
            let triesFromLevel = segue.destination as! PopUpViewController
            triesFromLevel.triesFromGameController = flipCount
        }
    }
}
