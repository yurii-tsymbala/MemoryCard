//
//  PopUpViewController.swift
//  MemoryCard
//
//  Created by Yurii on 28.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit
import CoreData

class PopUpViewController: UIViewController {
    
    override func viewDidLoad() {
        shareButton.isHidden = true
        timeLabel.text = "Time : \(timeFromGameController) seconds"
        trieLabel.text = "Tries : \(triesFromGameController)"
    }
    
    //  Amount of cards
    var cardsNumberFromGameController = 0
    
    //  Wasted time
    var timeFromGameController = 0
    
    // Amount of tries
    var triesFromGameController = 0
    
    // "Level completed" label
    @IBOutlet weak var levelNumberLabel: UILabel!
    
    // Amount of tries wasted in level
    @IBOutlet weak var trieLabel: UILabel!
    
    // Wasted time in level
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var RecordView: UIView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    // Shares info about level
    @IBAction func shareButton(_ sender: UIButton) {
        
        let screenForSharing = captureScreen()
        let activityVC = UIActivityViewController(activityItems: [screenForSharing!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func captureScreen() -> UIImage? {
        let screen = RecordView.window?.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions((screen?.frame.size)!, false, scale);
        screen?.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
    
    // Amount of coins
    @IBOutlet weak var coinLabel: UILabel!
    
    // Returns to Main Menu
    @IBAction func menuButton(_ sender: UIButton) {
        
        let startMenu = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let startMenuNav = UINavigationController(rootViewController: startMenu)
        startMenuNav.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = startMenuNav
        // Removes RecordMenu
        dismiss(animated: true, completion: nil)
    }
    
    // Restarts the level
    @IBAction func retryButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "retryButton"), object: self)
        dismiss(animated: true, completion: nil)
    }
    
    // Next level of the game
    @IBAction func nextLevelButton(_ sender: UIButton) {
        
        //TODO: nextLevelButton functionality
    }
    
    // MARK: - Core Data methods
    
    var firstTryOfLevel = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record") // назва твоєї схеми (Entity)
        
        do {
            results = try managedContext.fetch(fetchRequest) // в резалті знаходться результат з бази
        } catch let err as NSError {
            print("Failed to fetch items", err)
        }
        // Checking result by cardsNumber Key
        for result in results {
            let cardsResult = result.value(forKey: "cardsNumber") as! Int
            if (cardsResult == cardsNumberFromGameController) {
                firstTryOfLevel = true
            } }
        // If level was not completed = save first result to database
        if (!firstTryOfLevel) {
            saveNewResult()
        } else {
            // Level already completed -> save new best record
            saveBestRecordForLevel()
        }
        // Fetching data and printing to console
        do {
            results = try managedContext.fetch(fetchRequest)
        } catch let err as NSError {
            print("Failed to fetch items", err)
        }
        print("=== Best Records in DB ===")
        // Views all info from database
        for result in results {
            let tryResult = result.value(forKey: "tries") ?? 0
            let cardsResult = result.value(forKey: "cardsNumber") ?? 0
            let timeResult = result.value(forKey: "time") ?? 0
            print("LEVEL : [\(cardsResult)] cards || Tries : [\(tryResult)] fails || Time : [\(timeResult)] seconds")
        }
    }
    
    var results: [NSManagedObject]!
    
    func saveNewResult() {
        shareButton.isHidden = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        // Sending data to DataBase attributes
        let newResult = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context)
        newResult.setValue(cardsNumberFromGameController, forKey: "cardsNumber")
        newResult.setValue(triesFromGameController, forKey: "tries")
        newResult.setValue(timeFromGameController, forKey: "time")
        
        do {
            try context.save()
            results.append(newResult)
        } catch {
            print("error")
        }
    }
    
    func saveBestRecordForLevel(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        for result in results {
            let cardsResult = result.value(forKey: "cardsNumber") as! Int
            
            if (cardsResult == cardsNumberFromGameController) {
                let tryResult = result.value(forKey: "tries") as! Int
                let timeResult = result.value(forKey: "time") as! Int
                
                if tryResult > triesFromGameController && timeResult > timeFromGameController {
                    
                    result.setValue(triesFromGameController, forKey: "tries")
                    result.setValue(timeFromGameController, forKey: "time")
                    levelNumberLabel.text = "New best score and time"
                    shareButton.isHidden = false
                } else if tryResult > triesFromGameController {
                    
                    result.setValue(triesFromGameController, forKey: "tries")
                    levelNumberLabel.text = "New best score in level"
                    shareButton.isHidden = false
                } else if timeResult > timeFromGameController {
                    
                    result.setValue(timeFromGameController, forKey: "time")
                    levelNumberLabel.text = "New best time in level"
                    shareButton.isHidden = false
                }
            }
        }
        do {
            try context.save()
        } catch {
            print("error")
        }
    }
}
