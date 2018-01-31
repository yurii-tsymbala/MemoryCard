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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Record") // назва твоєї схеми (Entity)
        do {
            results = try managedContext.fetch(fetchRequest)
        } catch let err as NSError {
            print("Failed to fetch items", err)
        }
        saveNewResult()
    }
    
    
    override func viewDidLoad() {
        
        timeLabel.text = "Time : \(timeFromGameController) seconds"
        trieLabel.text = "Tries : \(triesFromGameController)"
    }
    
    var results: [NSManagedObject]!
    
    func saveNewResult() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let context = appDelegate.persistentContainer.viewContext
        // передаємо змінні які ми хочемо зберегти в базу
        let newResult = NSEntityDescription.insertNewObject(forEntityName: "Record", into: context) // назва схеми
        newResult.setValue(cardsNumberFromGameController, forKey: "cardsNumber") // тут жовтим атрибути в твоїй схемі
        newResult.setValue(triesFromGameController, forKey: "tries")
        newResult.setValue(timeFromGameController, forKey: "time")
        
        do {
            try context.save()
            results.append(newResult)
        } catch {
            print("error")
        }
    }

    //  Кількість карток
    var cardsNumberFromGameController = 0
    
    // Час
    var timeFromGameController = 0
    
    // Кількість спроб
    var triesFromGameController = 0
    
    // "Level completed" label
    @IBOutlet weak var levelNumberLabel: UILabel!
    
    // Amount of tries wasted in game
    @IBOutlet weak var trieLabel: UILabel!
    
    // Time wasted in game
    @IBOutlet weak var timeLabel: UILabel!
    
    // Amount of coins
    @IBOutlet weak var coinLabel: UILabel!
    
    // Returns to Main Menu
    @IBAction func menuButton(_ sender: UIButton) {
        let startMenu = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        let startMenuNav = UINavigationController(rootViewController: startMenu)
        startMenuNav.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = startMenuNav
        
        dismiss(animated: true, completion: nil)
    }
    
    // Reloads game from start
    @IBAction func retryButton(_ sender: UIButton) {
        
        // Виконуємо нотіфікейшн
        NotificationCenter.default.post(name: Notification.Name(rawValue: "retryButton"), object: self)
        
        dismiss(animated: true, completion: nil)
    }
    
    // Sends user to next level
    @IBAction func nextLevelButton(_ sender: UIButton) {
    }
}
