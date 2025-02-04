//
//  MainMenuViewController.swift
//  MemoryGame
//
//  Created by Alex Ch on 3.02.25.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func gameButtonTapped(_ sender: UIButton) {
        let vc = ViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    @IBAction func privacyPolicyTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Ooops", message: "there is no link to policy yet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
}
