//
//  MenuViewController.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit
import CoreData

class MenuViewController: UIViewController {
    
    var results: [NSManagedObject]!
    
    let imagesPackLabel = ["Pokemons", "Food", "Cars"]
    
    let imagesPack : [UIImage] = [
        UIImage (named : "pockemon")!,
        UIImage (named : "food")!,
        UIImage (named : "car")!
    ]
    
    let levelsPack = ["4","8", "12", "16", "20", "24", "28", "32", "36", "40"]
    
    var cardNumber = 4
    
    var imagePackName = "Pokemons"
    
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var imagePackCollectionView: UICollectionView!
    
    @IBOutlet weak var levelPackCollectionView: UICollectionView!
    
    @IBOutlet weak var coinLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePackCollectionView.delegate = self
        levelPackCollectionView.delegate = self
        imagePackCollectionView.dataSource = self
        imagePackCollectionView.dataSource = self
        imagePackCollectionView.backgroundColor = #colorLiteral(red: 0.2298397148, green: 0.2734779793, blue: 0.2721715065, alpha: 1)
        imagePackCollectionView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        imagePackCollectionView.layer.borderWidth = 5
        imageLabel.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        imageLabel.layer.borderWidth = 2
        imageLabel.layer.borderColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        fetchDataFromDB()
    }
    
    func fetchDataFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        do {
            results = try managedContext.fetch(fetchRequest)
        } catch let err as NSError {
            print("Failed to fetch items", err)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NumberOfCard" {
            let numberOfCardsFromCell = segue.destination as! GameViewController
            numberOfCardsFromCell.cardNumbersFromMenuController = cardNumber
            let imagePackNameFromCell = segue.destination as! GameViewController
            imagePackNameFromCell.imagePackLabelFromMenuController = imagePackName
        }
    }
}

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.imagePackCollectionView {
            
            // Changes color of imageCardCell
            imagePackCollectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
            
            // Saves name of imagePack from imagePackCell
            imagePackName = String(imagesPackLabel[indexPath.item])
            print("\(imagePackName) stickerPack Selected ")
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
}

extension MenuViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.imagePackCollectionView {
            return imagesPackLabel.count
        } else {
            return levelsPack.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.imagePackCollectionView {
            let cell: ImagePackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagePackCell", for: indexPath) as! ImagePackCollectionViewCell
            cell.imagePackView.image = imagesPack[indexPath.item]
            cell.nameOfImagePackView.text = imagesPackLabel[indexPath.item]
            
            // Design of imagePackCell
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1)
            UIView.animate(withDuration: 0.6, animations: { () -> Void in
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
            return cell
        } else {
            
            let cell: LevelPackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelPackCell", for: indexPath) as! LevelPackCollectionViewCell
            cell.numberOfLevel.text = levelsPack[indexPath.item]
            cell.scoreOfLevel.text = "Best score: -- tries"
            cell.timeOfLevel.text = "Best time: -- sec"
            
            for result in results {
                let tryResult = result.value(forKey: "tries") ?? 0
                let cardsResult = "\(result.value(forKey: "cardsNumber") ?? "0")"
                let timeResult = result.value(forKey: "time") ?? 0
                if cardsResult == levelsPack[indexPath.item] {
                    cell.scoreOfLevel.text = "Best score: \(tryResult) tries"
                    cell.timeOfLevel.text = "Best time: \(timeResult) sec"
                }
            }
            
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            UIView.animate(withDuration: 0.8, animations: { () -> Void in
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
            
            if indexPath.row < (results.count) {
                cell.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                cell.isUserInteractionEnabled = true
            } else if indexPath.row == results.count{
                cell.isUserInteractionEnabled = true
                cell.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
            }  else {
                cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
                cell.isUserInteractionEnabled = false
            }
            cell.layer.cornerRadius = 50
            cell.layer.borderWidth = 3
            
            return cell
        }
    }
}
