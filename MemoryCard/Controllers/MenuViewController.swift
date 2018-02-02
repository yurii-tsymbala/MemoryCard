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
    
    // Назви стікерпаків
    let imagesPackLabel = ["Pokemons", "Food", "Cars"]
    
    // Картинки стікерпаків
    let imagesPack : [UIImage] = [
        UIImage (named : "pockemon")!,
        UIImage (named : "food")!,
        UIImage (named : "car")!
    ]
    
    // Назви рівнів гри
    let levelsPack = ["8","10", "12", "16", "18", "24", "28", "30", "32", "36"]
    
    
    // MARK: CollectionView Methods
    
    // Повертає кількість клітинок в CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.imagePackCollectionView {
            return imagesPackLabel.count
        } else {
            return levelsPack.count
        }
    }
        
    // Повертає створену клітинку
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.imagePackCollectionView {
            // Створюю клітинку і присвоюю її власний клас
            let cell: ImagePackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePackCell", for: indexPath) as! ImagePackCollectionViewCell
            // Присвоюю фото в  клітинці
            cell.imagePackView.image = imagesPack[indexPath.item]
            // Присвоюю надпис в клітинці
            cell.nameOfImagePackView.text = imagesPackLabel[indexPath.item]
            
            //Дизайн клітинок
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
            
            // Створюю клітинку і присвоюю її власний клас
            let cell: LevelPackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelPackCell", for: indexPath) as! LevelPackCollectionViewCell
            // Присвоюю надпис в клітинці
            cell.numberOfLevel.text = levelsPack[indexPath.item]
            cell.scoreOfLevel.text = "Best score : -- tries"
            cell.timeOfLevel.text = "Best time : -- sec"
            
            //Дизайн клітинок
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
    // Змінна з дефолтним значенням карток з клітинки
    var cardNumber = 12
    
    // Змінна з дефолтним значенням назви стікерпаку з клітинки
    var imagePackName = "Pokemons"
    
    // Визначає клітинку, на яку нажато
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.imagePackCollectionView {
            
            // Змінює колір нажатої клітинки
             imagePackCollectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            // Змінюю бекграунд levelPackCollectionView
            levelPackCollectionView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            imagePackCollectionView.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            
            // Виводить індекс клітинки на яку нажимаю
            print("IndexOf ImagePackCell = \(indexPath.item)")
            
            // Виводить конкретну  назву стікерпаку карток
            imagePackName = String(imagesPackLabel[indexPath.item])
            print("\(imagePackName) stickerPack Selected ")
            
        } else {
            
            // Змінює колір нажатої клітинки
              levelPackCollectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            // Виводить індекс клітинки на яку нажимаю
            print("IndexOf LevelPackCell = \(indexPath.item)")
            
            // Виводить конкретне значення кількості карток
            cardNumber = Int(levelsPack[indexPath.item])!
            print("NumberOfCards in Level = \(cardNumber)" )
            
            // Виконує перехід на GameViewController
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
            }
            
            performSegue(withIdentifier: "NumberOfCard", sender: self)
        }
    }
    
    // Надсилає дані з клітинки в GameViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)  {
        if segue.identifier == "NumberOfCard" {
            // Кількість карток буде братись з клітинки Левелів LevelPackCell
            let numberOfCardsFromCell = segue.destination as! GameViewController
            numberOfCardsFromCell.cardNumbersFromMenuController = cardNumber
            
            // Назва стікерпаку буде братись з клітинки ImagePackCell
            let imagePackNameFromCell = segue.destination as! GameViewController
            imagePackNameFromCell.imagePackLabelFromMenuController = imagePackName
        }
    }
}
