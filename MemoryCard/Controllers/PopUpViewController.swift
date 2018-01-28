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
        super.viewDidLoad()
    }
    
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
    }
    
    // Reloads game from start
    @IBAction func retryButton(_ sender: UIButton) {
    }
    
    // Sends user to next level
    @IBAction func nextLevelButton(_ sender: UIButton) {
    }
    
}
