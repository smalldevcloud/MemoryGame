//
//  WinViewController.swift
//  MemoryGame
//
//  Created by Alex Ch on 3.02.25.
//

import UIKit

class WinViewController: UIViewController {

    @IBOutlet weak var gameTotalsLabel: UILabel!
    var textToSet: String!
    
    var delegate: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gameTotalsLabel.text = textToSet
    }
    
    @IBAction func newGameTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        delegate.newGamgeTapped()
    }
    
    @IBAction func menuTapped(_ sender: UIButton) {
        self.dismiss(animated: true)
        delegate.menuTapped()
    }
    
}

protocol WinViewDelegateProtocol {
    func newGamgeTapped()
    func menuTapped()
}
