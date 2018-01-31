//
//  PopUpViewController.swift
//  MemoryCard
//
//  Created by Yurii on 28.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {
    
    override func viewDidLoad() {
        
        timeLabel.text = "Time : \(timeFromGameController) seconds"
        trieLabel.text = "Tries : \(triesFromGameController)"
        super.viewDidLoad()
    }
    
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
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "retryButton"), object: self)
        
        dismiss(animated: true, completion: nil)
    }
    
    // Sends user to next level
    @IBAction func nextLevelButton(_ sender: UIButton) {
    }
    
}
