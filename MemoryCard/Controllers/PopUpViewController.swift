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
    
    private var resultsFromRecord: [NSManagedObject]!
    
    private var resultsFromCoins: [NSManagedObject]!
    
    private var firstTryOfLevel = false
    
    private var cardsNumberFromGameController = 0
    
    private var timeFromGameController = 0
    
    private var triesFromGameController = 0
    
    private var coinsFromLevel = 10
    
    @IBOutlet weak var levelNumberLabel: UILabel!
    
    @IBOutlet weak var trieLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var coinLabel: UILabel!
    
    @IBOutlet weak var recordView: UIView!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var retryButton: UIButton!
    
    @IBOutlet weak var nextLevelButton: UIButton!
    
    @IBAction func shareButton(_ sender: UIButton) {
        
        let screenForSharing = captureScreen()
        let activityVC = UIActivityViewController(activityItems: [screenForSharing!], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
    }
    
    private func captureScreen() -> UIImage? {
        let screen = recordView.window?.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions((screen?.frame.size)!, false, scale);
        screen?.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        return screenshot
    }
    
    @IBAction func menuButton(_ sender: UIButton) {
        let startMenu = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let startMenuNav = UINavigationController(rootViewController: startMenu)
        startMenuNav.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = startMenuNav
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func retryButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "retryButton"), object: self)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextLevelButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "nextLevelButton"), object: self)
        dismiss(animated: true, completion: nil)
    }
    
    private func viewDesign() {
        shareButton.isHidden = true
        timeLabel.text = "Time : \(timeFromGameController) seconds"
        trieLabel.text = "Tries : \(triesFromGameController)"
        coinLabel.text = "Coins : + \(coinsFromLevel)"
        view.backgroundColor = UIColor.Backgrounds.darkYellow
        recordView.backgroundColor = UIColor.Backgrounds.lightRed
        recordView.layer.cornerRadius = CGFloat.Design.CornerRadius
        recordView.layer.borderWidth = CGFloat.Design.BorderWidth
        menuButton.backgroundColor = UIColor.Backgrounds.darkOrange
        menuButton.layer.cornerRadius = CGFloat.Design.buttonCornerRadiuis
        menuButton.layer.borderWidth = CGFloat.Design.buttonBorderWidth
        retryButton.backgroundColor = UIColor.Backgrounds.mediumOrange
        retryButton.layer.cornerRadius = CGFloat.Design.buttonCornerRadiuis
        retryButton.layer.borderWidth = CGFloat.Design.buttonBorderWidth
        nextLevelButton.backgroundColor = UIColor.Backgrounds.lightOrange
        nextLevelButton.layer.cornerRadius = CGFloat.Design.buttonCornerRadiuis
        nextLevelButton.layer.borderWidth = CGFloat.Design.buttonBorderWidth
        shareButton.layer.cornerRadius = CGFloat.Design.buttonCornerRadiuis
        shareButton.layer.borderWidth = CGFloat.Design.buttonBorderWidth
        shareButton.backgroundColor = UIColor.Backgrounds.darkBlue
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkForFirstTry()
        fetchDataFromDB()
    }
    
    func checkForFirstTry() {
        for result in resultsFromRecord {
            // Checking result by cardsNumber Key
            let cardsResult = result.value(forKey: "cardsNumber") as! Int
            if (cardsResult == cardsNumberFromGameController) {
                firstTryOfLevel = true
            }
        }
        if (!firstTryOfLevel) {
            saveNewResult()
        } else {
            saveBestRecordForLevel()
        }
    }
    
    func fetchDataFromDB() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequestRecord = NSFetchRequest<NSManagedObject>(entityName: "Record")
        let fetchRequestCoin = NSFetchRequest<NSManagedObject>(entityName: "Coins")
        do {
            resultsFromRecord = try managedContext.fetch(fetchRequestRecord)
            resultsFromCoins = try managedContext.fetch(fetchRequestCoin)
        } catch let err as NSError {
            print("Failed to fetch items", err)
        }
    }
    
    func printDataFromDB() {
        print("================= BEST RECORDS IN DATABASE =================")
        // Views all info from database
        for result in resultsFromRecord {
            let cardsResult = result.value(forKey: "cardsNumber") ?? 0
            let tryResult = result.value(forKey: "tries") ?? 0
            let timeResult = result.value(forKey: "time") ?? 0
            print("LEVEL : [\(cardsResult)] cards || TRIES : [\(tryResult)] fails || TIME : [\(timeResult)] seconds")
        }
        for resultOfCoin in resultsFromCoins {
            let coinsResult = resultOfCoin.value(forKey: "coins") ?? 0
            print("COINS: + \(coinsResult)")
        }
    }
    
    func saveNewResult() {
        shareButton.isHidden = false
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        
        let newResultOfRecord = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context)
        newResultOfRecord.setValue(cardsNumberFromGameController, forKey: "cardsNumber")
        newResultOfRecord.setValue(triesFromGameController, forKey: "tries")
        newResultOfRecord.setValue(timeFromGameController, forKey: "time")
        
        let newResultOfCoin = NSEntityDescription.insertNewObject(forEntityName: "Coins", into: context)
        newResultOfCoin.setValue(coinsFromLevel, forKey: "coins")
        do {
            try context.save()
            resultsFromRecord.append(newResultOfRecord)
            resultsFromCoins.append(newResultOfCoin)
        } catch {
            print("error")
        }
        printDataFromDB()
    }
    
    func saveBestRecordForLevel() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        for result in resultsFromRecord {
            let cardsResult = result.value(forKey: "cardsNumber") as! Int
            if (cardsResult == cardsNumberFromGameController) {
                let tryResult = result.value(forKey: "tries") as! Int
                let timeResult = result.value(forKey: "time") as! Int
                
                if tryResult > triesFromGameController && timeResult > timeFromGameController {
                    result.setValue(triesFromGameController, forKey: "tries")
                    result.setValue(timeFromGameController, forKey: "time")
                    levelNumberLabel.text = "New score & time"
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
        printDataFromDB()
    }
}
