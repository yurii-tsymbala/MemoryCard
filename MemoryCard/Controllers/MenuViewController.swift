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
    
    // Назви фото-категорій
    let imagesPackLabel = ["Pokemons", "Food", "Cars"]
    // Картинки категорій
    let imagesPack : [UIImage] = [
        UIImage (named : "pokemon")!,
        UIImage (named : "food")!,
        UIImage (named : "car")!
    ]
    
    // Назви рівнів гри
    let levelsPack = ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5", "Level 6", "Level 7", "Level 8", "Level 9"]
    
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
            
            return cell
            
        }
    }
    // Визначає клітинку, на яку нажато
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Виводить індекс клітинки на яку нажимаю
        print("Index of the cell = \(indexPath.item)")
        
        // Клітинка, яку вибрав юзер
       // let cell = collectionView.cellForItem(at: indexPath) as! ImagePackCollectionViewCell
    }
}
