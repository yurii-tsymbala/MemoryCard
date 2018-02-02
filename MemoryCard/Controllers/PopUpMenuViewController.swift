//
//  PopUpMenuViewController.swift
//  MemoryCard
//
//  Created by Yurii on 28.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class PopUpMenuViewController: UIViewController {
    
    // "Game is paused" label
    @IBOutlet weak var pauseLabel: UILabel!
    
    // Returns to main menu
    @IBAction func quitButton(_ sender: UIButton) {
        //TODO: розібратись як працєю
        let startMenu = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        let startMenuNav = UINavigationController(rootViewController: startMenu)
        startMenuNav.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = startMenuNav
        dismiss(animated: true, completion: nil)
    }
    
    // Restarts the level
    @IBAction func resetButton(_ sender: UIButton) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "retryButton"), object: self)
        dismiss(animated: true, completion: nil)
    }
    
    // Disables pause
    @IBAction func continueButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
