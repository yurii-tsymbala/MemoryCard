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
    
    private var results: [NSManagedObject]!
    
    private var coins: [NSManagedObject]!
    
    private let imagesPackLabel = ["Pokemons", "Food", "Cars"]
    
    private let imagesPack : [UIImage] = [
        UIImage (named : "pockemon")!,
        UIImage (named : "food")!,
        UIImage (named : "car")!
    ]
    
    private let levelsPack = ["4","8", "12", "16", "20", "24", "28", "32", "36", "40","44","48","52","56"]
    
    private var cardNumber = 4
    
    private var imagePackName = "Pokemons"
    
    private var titles = ""
    
    private var message = ""
    
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var imagePackCollectionView: UICollectionView!
    
    @IBOutlet weak var levelPackCollectionView: UICollectionView!
    
    @IBOutlet weak var coinLabel: UILabel!
    
   private func viewDesign() {
        view.backgroundColor = UIColor.Backgrounds.mainYellow
        levelPackCollectionView.backgroundColor = UIColor.Backgrounds.mainYellow
        imagePackCollectionView.backgroundColor = UIColor.Backgrounds.mediumGray
        imagePackCollectionView.layer.borderColor = UIColor.Backgrounds.lightBlack.cgColor
        imagePackCollectionView.layer.borderWidth = CGFloat.Design.BorderWidth * 2
    }
    
 override func viewDidLoad() {
        super.viewDidLoad()
        imagePackCollectionView.delegate = self
        levelPackCollectionView.delegate = self
        imagePackCollectionView.dataSource = self
        imagePackCollectionView.dataSource = self
        viewDesign()
        parseJson()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchDataFromDB()
    }
    
    private func fetchDataFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record")
        let fetchRequestCoins = NSFetchRequest<NSManagedObject>(entityName: "Coins")
        do {
            results = try managedContext.fetch(fetchRequest)
            coins = try managedContext.fetch(fetchRequestCoins)
        } catch let err as NSError {
            print("Failed to fetch items", err)
        }
        if coins.count > 0 {
            let temp = coins[0]
            if let coin = temp.value(forKey: "coins") {
                coinLabel.text = "\(coin)"
            }
        }
    }
    
  private func parseJson() {
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
    
  private func showAlert(_ title: String, _ message: String) {
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
            cellDesign(cell: cell)
            cell.numberOfLevel.text = levelsPack[indexPath.item]
            cell.scoreOfLevel.text = "Best score: -- tries"
            cell.timeOfLevel.text = "Best time: -- sec"
            
            if indexPath.row < (results.count) {
                cell.backgroundColor = #colorLiteral(red: 0.1062374366, green: 0.5365244289, blue: 0.1832579575, alpha: 0.7509899401)
            } else if indexPath.row == results.count {
                cell.backgroundColor = #colorLiteral(red: 0.6932503173, green: 0.07950783619, blue: 0.01839272857, alpha: 0.6007063356)
            } else {
                cell.backgroundColor = #colorLiteral(red: 0.3663622747, green: 1, blue: 0.7238394915, alpha: 0.1096960616)
            }
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
    
 private func cellDesign(cell: LevelPackCollectionViewCell ) {
        cell.layer.cornerRadius = CGFloat.Design.CornerRadius
        cell.layer.borderWidth = CGFloat.Design.BorderWidth
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        UIView.animate(withDuration: 0.8, animations: { () -> Void in
            cell.alpha = 1
            cell.layer.transform = CATransform3DScale(CATransform3DIdentity, 1, 1, 1)
        })
    }
}

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.imagePackCollectionView {
            imagePackCollectionView.cellForItem(at: indexPath)?.backgroundColor = UIColor.Backgrounds.darkBlue
            imagePackName = String(imagesPackLabel[indexPath.item])
            print("\(imagePackName) stickerPack Selected ")
        } else {
            if indexPath.row > (results.count) {
                titles = "No access"
                message = "Pass previous levels"
                showAlert(titles, message)
                return
            }
            cardNumber = Int(levelsPack[indexPath.item])!
            print("NumberOfCards in Level = \(cardNumber)")
            performSegue(withIdentifier: "NumberOfCard", sender: self)
        }
    }
}
