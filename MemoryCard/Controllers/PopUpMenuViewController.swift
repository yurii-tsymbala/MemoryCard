//
//  PopUpMenuViewController.swift
//  MemoryCard
//
//  Created by Yurii on 28.01.18.
//  Copyright © 2018 Yurii. All rights reserved.
//

import UIKit

class PopUpMenuViewController: UIViewController {
    
    @IBOutlet weak var menuView: UIView!
    
    @IBOutlet weak var pauseLabel: UILabel!
    
    @IBOutlet weak var quitButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
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
    
    @IBAction func continueButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewDesign()
    }
    
    func viewDesign() {
        view.backgroundColor = UIColor.Backgrounds.darkYellow
        quitButton.backgroundColor = UIColor.Backgrounds.darkOrange
        quitButton.layer.cornerRadius = CGFloat.Design.buttonCornerRadiuis
        quitButton.layer.borderWidth = CGFloat.Design.buttonBorderWidth
        resetButton.backgroundColor = UIColor.Backgrounds.mediumOrange
        resetButton.layer.cornerRadius = CGFloat.Design.buttonCornerRadiuis
        resetButton.layer.borderWidth = CGFloat.Design.buttonBorderWidth
        continueButton.backgroundColor = UIColor.Backgrounds.lightOrange
        continueButton.layer.cornerRadius = CGFloat.Design.buttonCornerRadiuis
        continueButton.layer.borderWidth = CGFloat.Design.buttonBorderWidth
        menuView.layer.cornerRadius = CGFloat.Design.CornerRadius
        menuView.layer.borderWidth = CGFloat.Design.BorderWidth
        menuView.backgroundColor = UIColor.Backgrounds.lightRed
        
    }
}
