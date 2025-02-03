//
//  SettingsViewController.swift
//  MemoryGame
//
//  Created by Alex Ch on 3.02.25.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var soundButton: UIButton!
    
    @IBOutlet weak var vibroButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupButtons()
    }
    
    func setupButtons() {
        if UserDefaultsManager.shared.getSoundEnabled() {
            soundButton.setImage(UIImage(named: "Speaker"), for: .normal)
        } else {
            soundButton.setImage(UIImage(named: "Mute Sound"), for: .normal)
        }
        
        if UserDefaultsManager.shared.getVibroEnabled() {
            vibroButton.setImage(UIImage(named: "Vibro"), for: .normal)
        } else {
            vibroButton.setImage(UIImage(named: "NoVibro"), for: .normal)
        }
    }
    
    @IBAction func resumeTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func menuTapped(_ sender: UIButton) {
        print("menu tapped -=")
    }
    
    @IBAction func soundTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.setSound()
        setupButtons()
    }
    
    @IBAction func vibroTapped(_ sender: UIButton) {
        UserDefaultsManager.shared.setVibro()
        setupButtons()
    }
    
}
