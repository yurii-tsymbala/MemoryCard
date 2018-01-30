//
//  PopUpMenuViewController.swift
//  MemoryCard
//
//  Created by Yurii on 28.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class PopUpMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // "Game is paused" label
    @IBOutlet weak var pauseLabel: UILabel!
    
    // Returns to main menu
    @IBAction func quitButton(_ sender: UIButton) {
        
        let startMenu = self.storyboard?.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        let startMenuNav = UINavigationController(rootViewController: startMenu)
        startMenuNav.isNavigationBarHidden = true
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.window?.rootViewController = startMenuNav
        
         dismiss(animated: true, completion: nil)
    }
    
    // Reloads game from start
    @IBAction func resetButton(_ sender: UIButton) {
    }
    
    // Disables pause
    @IBAction func continueButton(_ sender: UIButton) {
    // Pовертає на контролер з грою
          //timerStart()
          dismiss(animated: true, completion: nil)
    }
    
}



