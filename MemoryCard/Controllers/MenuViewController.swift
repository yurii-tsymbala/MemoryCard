//
//  MenuViewController.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        imagePackCollectionView.delegate = self
        imagePackCollectionView.dataSource = self
        
        levelPackCollectionView.delegate = self
        imagePackCollectionView.dataSource = self
        super.viewDidLoad()
    }
    
    // Текст : "Choose Image Pack"
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var imagePackCollectionView: UICollectionView!
    
    @IBOutlet weak var levelPackCollectionView: UICollectionView!
    
    // Назви стікерпаків
    let imagesPackLabel = ["Pokemons", "Food", "Cars"]
    
    // Картинки стікерпаків
    let imagesPack : [UIImage] = [
        UIImage (named : "pockemon")!,
        UIImage (named : "food")!,
        UIImage (named : "car")!
    ]
    
    // Назви рівнів гри
    let levelsPack = [ "12", "16", "18", "24", "28", "30"]
    
    
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
            
            return cell
        } else {
            // Створюю клітинку і присвоюю її власний клас
            let cell: LevelPackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelPackCell", for: indexPath) as! LevelPackCollectionViewCell
            // Присвоюю надпис в клітинці
            cell.numberOfLevel.text = levelsPack[indexPath.item]
            cell.backgroundColor = UIColor.lightGray
            
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
            // Виводить індекс клітинки на яку нажимаю
            print("IndexOf ImagePackCell = \(indexPath.item)")
            
            // Виводить конкретну  назву стікерпаку карток
            imagePackName = String(imagesPackLabel[indexPath.item])
            print("\(imagePackName) stickerPack Selected ")
            
        } else {
            // Виводить індекс клітинки на яку нажимаю
            print("IndexOf LevelPackCell = \(indexPath.item)")
            
            // Виводить конкретне значення кількості карток
            cardNumber = Int(levelsPack[indexPath.item])!
            print("NumberOfCards in Level = \(cardNumber)" )
            
            // Виконує перехід на GameViewController
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
