//
//  GameViewController.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    var model = CardModel()
    
    var cardArray = [Card]()
    
    var timer: Timer?
    
    var seconds = 0
    
    var flipCount = 0 {
        didSet {
            flipCountLabel.text = "Tries : \(flipCount)"
        }
    }
    
    var firstFlippedCardIndex:IndexPath?
    
    var cardNumbersFromMenuController = 4
    
    var imagePackLabelFromMenuController = "Pokemons"
    
    let cellMagrings: CGFloat = 5
    
    @IBOutlet weak var cardCollectionView: UICollectionView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var flipCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cardCollectionView.delegate = self
        cardCollectionView.dataSource = self
        newGame()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "retryButton"), object: nil, queue: OperationQueue.main)
        { (notification) in
            self.newGame()
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "nextLevelButton"), object: nil, queue: OperationQueue.main)
        { (notification) in
            self.cardNumbersFromMenuController += 4
            self.newGame()
        }
    }
    
    // MARK: Timer Methods
    
    @IBAction func menuButton(_ sender: UIButton) {
        timer?.invalidate()
    }
    
    func timerStart() {
        if !(timer?.isValid ?? false) {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        }
    }
    
    @objc func timerElapsed() {
        seconds += 1
        timerLabel.text = "Time : \(seconds)"
    }
    
    // MARK: Game Logic Methods
    
    func newGame() {
        cardArray = model.getCards(cardNumberInModel: cardNumbersFromMenuController,imagePackInModel: imagePackLabelFromMenuController )
        seconds = 0
        timerLabel.text = "Time : \(seconds)"
        flipCount = 0
        flipCountLabel.text = "Tries : \(flipCount)"
        cardCollectionView.reloadData()
    }
    
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
            flipCount += 1
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
    
    func checkGameEnded(){
        var isWon = true
        for card in cardArray {
            if card.isMatched == false{
                isWon = false
                break
            }
        }
        if isWon == true {
            timer?.invalidate()
            performSegue(withIdentifier: "RecordSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

extension GameViewController:  UICollectionViewDataSource {
    
    func cellsRowAndColomn() -> (cellInRow: Int, cellInColomn: Int) {
        var cellInRow = Int(floor(sqrt(Double(cardNumbersFromMenuController))))
        while (cardNumbersFromMenuController % cellInRow != 0) {
            cellInRow -= 1
            if (cellInRow == 1) {
                break
            }
        }
        let cellInColomn = cardNumbersFromMenuController / cellInRow
        return (cellInRow, cellInColomn)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cardCollectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
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
}

extension GameViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        timerStart()
        let cell = cardCollectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        let card = cardArray[indexPath.row]
        // Logic of Cards checking
        if card.isFlipped == false && card.isMatched == false {
            cell.flip()
            card.isFlipped = true
            if firstFlippedCardIndex == nil {
                firstFlippedCardIndex = indexPath
            } else {
                checkForMatches(indexPath)
            }
        }
    }
}

extension GameViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.frame.width
        let screenHeight = collectionView.frame.height
        let cell = cellsRowAndColomn()
        if (screenWidth < screenHeight) {
            return CGSize(width: screenWidth/CGFloat(cell.cellInRow) - cellMagrings, height: screenHeight/CGFloat(cell.cellInColomn) - cellMagrings)
        } else {
            return CGSize(width: screenWidth/CGFloat(cell.cellInColomn) - cellMagrings, height: screenHeight/CGFloat(cell.cellInRow) - cellMagrings)
        }
    }
}
