//
//  MainMenuViewController.swift
//  MemoryGame
//
//  Created by Alex Ch on 3.02.25.
//

import UIKit
import SafariServices
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
        
        let link = "https://github.com/smalldevcloud/MemoryGame"
        if let url = URL(string: link) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
}
