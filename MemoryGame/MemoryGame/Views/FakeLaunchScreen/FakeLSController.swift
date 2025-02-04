//
//  FakeLSController.swift
//  MemoryGame
//
//  Created by Alex Ch on 3.02.25.
//

import UIKit

class FakeLSController: UIViewController {

    var fireImageView = UIImageView()
    let fireImage = UIImage(named: "fire")

    override func viewDidLoad() {
        super.viewDidLoad()
        fireImageView.image = fireImage
        fireImageView.contentMode = .scaleAspectFit
        view.addSubview(fireImageView)
        
        self.fireImageView.frame = CGRect(x: 0, y: 55, width: 400, height: 400)

        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveEaseInOut, .autoreverse, .repeat]) {
            UIView.modifyAnimations(withRepeatCount: 2, autoreverses: true) {
                self.fireImageView.frame = CGRect(x: 0, y: 400, width: 400, height: 400);
            }
        } completion: { _ in
            let vc = MainMenuViewController()
            vc.modalPresentationStyle = .fullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: false) 
        }
    }


}
