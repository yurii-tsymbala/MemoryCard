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
        newGame()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "retryButton"), object: nil, queue: OperationQueue.main)
        { (notification) in
            self.newGame()
        }
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
    }
    
    // Дефолтне значення кількості карток з MenuViewController
    var cardNumbersFromMenuController = 8
    // Дефолтне значення  назви стікерпаку з MenuViewController
    var imagePackLabelFromMenuController = "Pokemons"
    
    // Creats new game
    func newGame(){
        
        // Entering in cardArray cards from CardModel
        cardArray = model.getCards(cardNumberInModel: cardNumbersFromMenuController,imagePackInModel: imagePackLabelFromMenuController )
        
        seconds = 0
        timerLabel.text = "Time : \(seconds)"
        flipCount = 0
        flipCountLabel.text = "Tries : \(flipCount)"
        // Updating view
        cardCollectionView.reloadData()
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        // stops timer
        timer?.invalidate()
    }
    
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
        seconds += 1
        timerLabel.text = "Time : \(seconds)"
    }
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    // When flipCount changes -> didset works
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Tries : \(flipCount)"
        }
    }
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    var model = CardModel()
    
    var cardArray = [Card]()
    
    // Index of the card that was flipped first
    var firstFlippedCardIndex:IndexPath?
    
    // MARK: - CollectionView Methods
    
    // Returns the size of the cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let screenWidth = Int(cardCollectionView.frame.width)
        let screenHeight = Int(cardCollectionView.frame.height)
        
        var size = CGSize(width: screenWidth/3, height: screenHeight/6)
        
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
            //  Default value for 8 cards
            size = CGSize(width: screenWidth/2, height: screenHeight/4)
        }
        return size
    }
    
    // Returns number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    // Returns created cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Creating the card
        let card = cardArray[indexPath.row]
        
        // Entering card to the cell
        cell.setCard(card)
        
        // Design of CardCell
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
        UIView.animate(withDuration: 0.6, animations: { () -> Void in
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        })
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Starting the timer when cell selected
        timerStart()
        
        // Cell that user selected
        let cell = cardCollectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Card that user selected
        let card = cardArray[indexPath.row]
        
        print("IndexOf CardCell = \(indexPath.item)")
        
        // Logic of Cards checking
        if card.isFlipped == false && card.isMatched == false {
            
            // Flipping selected card
            cell.flip()
            card.isFlipped = true
            
            // Checking wich card turns first
            if firstFlippedCardIndex == nil {
                
                // setting index to firstFlippedCard
                firstFlippedCardIndex = indexPath
            } else {
                checkForMatches(indexPath)
            }
        }
    }
    
    //MARK: Game Logic Methods
    
    // Checking the cards for matching
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
            
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Deleting cards with animation
            // delay for deleting animation
            cardCollectionView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                self.cardCollectionView.isUserInteractionEnabled = true
                cardOneCell?.remove()
                cardTwoCell?.remove()
            }
            
            // delay for deleting animation
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                // Deleting cells
                cardOneCell?.removeFromSuperview()
                cardTwoCell?.removeFromSuperview()
                
                // checking if any cards are left
                self.checkGameEnded()
            }
        } else {
            
            flipCount += 1 // додаю невдалу спробу
            
            //статус двох карт
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            //повертаю картки в дефолтний стан
            cardCollectionView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                self.cardCollectionView.isUserInteractionEnabled = true
                cardOneCell?.flipback()
                cardTwoCell?.flipback()
            }
        }
        // Reloading cell of first flipped card
        if cardOneCell == nil {
            cardCollectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        //  deleting index of first flipped cell"card"
        firstFlippedCardIndex = nil
    }
    
    // Checking if there are no cards left in game
    func checkGameEnded(){
        var isWon = true
        for card in cardArray {
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        // If there are no cards left : stopping timer+moving to recordview
        if isWon == true {
            timer?.invalidate()
            performSegue(withIdentifier: "RecordSegue", sender: self)
        }
    }
    
    // Sends data (time and tries) to PopUpViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "RecordSegue" {
            
            let cardsNumberFromLevel = segue.destination as! PopUpViewController
            cardsNumberFromLevel.cardsNumberFromGameController = cardNumbersFromMenuController
            
            let timeFromLevel = segue.destination as! PopUpViewController
            timeFromLevel.timeFromGameController = seconds
            
            let triesFromLevel = segue.destination as! PopUpViewController
            triesFromLevel.triesFromGameController = flipCount
        }
    }
}
