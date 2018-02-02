//
//  MenuViewController.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    // інфу в клітинки закидувати через кордату
    // якшо результат кращий за попередній кнопка фейсбук вискакує
    
    override func viewDidLoad() {
        imagePackCollectionView.delegate = self
        levelPackCollectionView.delegate = self
        imagePackCollectionView.dataSource = self
        imagePackCollectionView.dataSource = self
    }
    
    // "Choose Image Pack" label
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var imagePackCollectionView: UICollectionView!
    
    @IBOutlet weak var levelPackCollectionView: UICollectionView!
    
    // "Earned coins" label
    @IBOutlet weak var coinLabel: UILabel!
    
    // Array of imagePacks
    let imagesPackLabel = ["Pokemons", "Food", "Cars"]
    
    // Images of imagePacks
    let imagesPack : [UIImage] = [
        UIImage (named : "pockemon")!,
        UIImage (named : "food")!,
        UIImage (named : "car")!
    ]
    
    // Array of numberOfCards = "Levels"
    let levelsPack = ["8","10", "12", "16", "18", "24", "28", "30", "32", "36"]
    
    // MARK: CollectionView Methods
    
    // Returns amount of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.imagePackCollectionView {
            return imagesPackLabel.count
        } else {
            return levelsPack.count
        }
    }
    
    // Returns created cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.imagePackCollectionView {
            // Creating imagePackCell
            let cell: ImagePackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePackCell", for: indexPath) as! ImagePackCollectionViewCell
            // Adding image of imagePack in cell
            cell.imagePackView.image = imagesPack[indexPath.item]
            // Adding name of imagePack in cell
            cell.nameOfImagePackView.text = imagesPackLabel[indexPath.item]
            
            // Design of imagePackCell
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
            cell.backgroundColor = #colorLiteral(red: 1, green: 0.6748031922, blue: 0.3668660089, alpha: 1)
            cell.layer.cornerRadius = 15
            cell.layer.borderWidth = 2
            
            return cell
        } else {
            
            let cell: LevelPackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelPackCell", for: indexPath) as! LevelPackCollectionViewCell
            cell.numberOfLevel.text = levelsPack[indexPath.item]
            cell.scoreOfLevel.text = "Best score : -- tries"
            cell.timeOfLevel.text = "Best time : -- sec"
            
            // Design of levelPackCell
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            UIView.animate(withDuration: 0.8, animations: { () -> Void in
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
            cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            cell.layer.cornerRadius = 50
            cell.layer.borderWidth = 3
            
            return cell
        }
    }
    // Default value of cardNumber
    var cardNumber = 8
    
    // Default value of imagePackName
    var imagePackName = "Pokemons"
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.imagePackCollectionView {
            
            // Changes color of imageCardCell
            imagePackCollectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            // Changes background of views
            levelPackCollectionView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            imagePackCollectionView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            // Saves name of imagePack from imagePackCell
            imagePackName = String(imagesPackLabel[indexPath.item])
            print("\(imagePackName) stickerPack Selected ")
            print("IndexOf ImagePackCell = \(indexPath.item)")
            
        } else {
            
            // Changes color of levelCardCell
            levelPackCollectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            // Saves numberOfCards from levelPackCell
            cardNumber = Int(levelsPack[indexPath.item])!
            print("NumberOfCards in Level = \(cardNumber)")
            print("IndexOf LevelPackCell = \(indexPath.item)")
            
            performSegue(withIdentifier: "NumberOfCard", sender: self)
        }
    }
    
    // Sends data from cell to GameViewController by segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "NumberOfCard" {
            
            let numberOfCardsFromCell = segue.destination as! GameViewController
            numberOfCardsFromCell.cardNumbersFromMenuController = cardNumber
            
            let imagePackNameFromCell = segue.destination as! GameViewController
            imagePackNameFromCell.imagePackLabelFromMenuController = imagePackName
        }
    }
}
