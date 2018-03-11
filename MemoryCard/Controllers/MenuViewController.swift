//
//  MenuViewController.swift
//  MemoryCard
//
//  Created by Yurii on 25.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit
import CoreData

var imagesPic = [Image]()

class MenuViewController: UIViewController {
    
    var results: [NSManagedObject]!
    
    let imagesPackLabel = ["Pokemons", "Food", "Cars"]
    
    let imagesPack : [UIImage] = [
        UIImage (named : "pockemon")!,
        UIImage (named : "food")!,
        UIImage (named : "car")!
    ]
    
    let levelsPack = ["4","8", "12", "16", "20", "24", "28", "32", "36", "40","44","48","52","56"]
    
    var cardNumber = 4
    
    var imagePackName = "Pokemons"
    
    var titles = ""
    
    var message = ""
    
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
        parseJson()
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
    
    func parseJson(){
        let jsonUrlString = "https://raw.githubusercontent.com/yurii-tsymbala/Assets/master/images.json"
        guard let url = URL(string: jsonUrlString) else { return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            do {
                imagesPic = try JSONDecoder().decode([Image].self, from: data)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert,animated: true, completion: nil)
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
            return cell
        } else {
            let cell: LevelPackCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "LevelPackCell", for: indexPath) as! LevelPackCollectionViewCell
            cell.numberOfLevel.text = levelsPack[indexPath.item]
            cell.scoreOfLevel.text = "Best score: -- tries"
            cell.timeOfLevel.text = "Best time: -- sec"
            
            if indexPath.row < (results.count) {
                cell.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            } else if indexPath.row == results.count {
                cell.backgroundColor = #colorLiteral(red: 0.7972514629, green: 0.6857745647, blue: 0.05130522698, alpha: 1)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
            cell.layer.cornerRadius = 50
            cell.layer.borderWidth = 3
            cell.alpha = 0
            cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
            UIView.animate(withDuration: 0.8, animations: { () -> Void in
                cell.alpha = 1
                cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
            })
            for result in results {
                let tryResult = result.value(forKey: "tries") ?? 0
                let cardsResult = "\(result.value(forKey: "cardsNumber") ?? "0")"
                let timeResult = result.value(forKey: "time") ?? 0
                if cardsResult == levelsPack[indexPath.item] {
                    cell.scoreOfLevel.text = "Best score: \(tryResult) tries"
                    cell.timeOfLevel.text = "Best time: \(timeResult) sec"
                }
            }
            return cell
        }
    }
}

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.imagePackCollectionView {
            // Changes color of imageCardCell
            imagePackCollectionView.cellForItem(at: indexPath)?.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
            // Saves name of imagePack from imagePackCell
            imagePackName = String(imagesPackLabel[indexPath.item])
            print("\(imagePackName) stickerPack Selected ")
        } else {
            if indexPath.row > (results.count) {
                titles = "No access"
                message = "Pass previous levels"
                showAlert(titles, message)
            }
            // Saves numberOfCards from levelPackCell
            cardNumber = Int(levelsPack[indexPath.item])!
            print("NumberOfCards in Level = \(cardNumber)")
            print("IndexOf LevelPackCell = \(indexPath.item)")
            
            performSegue(withIdentifier: "NumberOfCard", sender: self)
        }
    }
}
