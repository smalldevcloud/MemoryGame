//
//  ViewController.swift
//  MemoryGame
//
//  Created by 8 on 9.08.24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    var viewModel = GameViewModel()
    var cards: [Card] = []
    let udManager = UserDefaultsManager.shared
    var player: AVAudioPlayer?
    
    @IBAction func newGameTapped(_ sender: UIButton) {
        // MARK: перезапуск игры
        newGamgeTapped()
    }
    
    @IBAction func settingsTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            let vc = SettingsViewController()
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        menuTapped()
    }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Ooops", message: "pause not implemented yet", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
            alert.dismiss(animated: true)
        })
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindMainState()
        self.bindStepsState()
        self.bindTimerState()
        self.viewModel.start()
        self.viewModel.startNewGame()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    func setupUI() {
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.contentInsetAdjustmentBehavior = .always
        let collectionNib = UINib(nibName: "CollectionViewCell", bundle: nil)
        self.collectionView.register(collectionNib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
    }
    
    func bindMainState() {
        viewModel.mainState.bind { [weak self] (newState) in
            switch newState {
            case .firstLaunch:
                self?.collectionView.reloadData()
            case let .newGameStarted(newCards):
                self?.cards = newCards
                self?.collectionView.reloadData()
            case let .openCard(index):
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: index, section: 0)
                    self?.collectionView.reloadItems(at: [indexPath])
                }
            case let .updateCollection(action):
                switch action {
                case .gussed:
                    self?.successInteraction()
                case .notGuessed:
                    self?.failInteraction()
                case .firstTap:
                    print("do nothing")
                }
                self?.collectionView.reloadData()
            case .gameOver:
                DispatchQueue.main.async {
                    guard let strongSelf = self else { return }
                    let vc = WinViewController()
                    vc.delegate = self
                    self?.winInteraction()
                    if let time = strongSelf.timerLabel.text, let steps = strongSelf.movesLabel.text {
                        vc.textToSet = "\(time)\n\(steps)"
                        vc.modalPresentationStyle = .formSheet
                        strongSelf.present(vc, animated: true)
                    }
                }

            }
        }
    }
    
    func bindStepsState() {
        viewModel.stepsState.bind { [weak self] (newValue) in
            switch newValue {
            case .zeroState:
                self?.movesLabel.text = "MOVIES: 0"
            case let .newValue(step):
                self?.movesLabel.text = "MOVIES: \(step)"
            }
        }
    }
    
    func bindTimerState() {
        viewModel.timerState.bind { [weak self] (newValue) in
            switch newValue {
            case .zeroState:
                self?.timerLabel.text = "TIME: 00:00"
            case let .newValue(value):
                self?.timerLabel.text = "TIME: \(value)"
            }
        }
    }
    
    func successInteraction() {
        if udManager.getVibroEnabled() {
            DispatchQueue.main.async {
                Vibration.success.vibrate()
            }
        }
        
        if udManager.getSoundEnabled() {
            DispatchQueue.main.async {
                self.playSound(soundName: "success")
            }
        }
    }
    
    func failInteraction() {
        if udManager.getVibroEnabled() {
            DispatchQueue.main.async {
                Vibration.error.vibrate()
            }
        }
        
        if udManager.getSoundEnabled() {
            DispatchQueue.main.async {
                self.playSound(soundName: "fail")
            }
        }
    }
    
    func winInteraction() {
        if udManager.getSoundEnabled() {
            DispatchQueue.main.async {
                self.playSound(soundName: "level-up")
            }
        }
    }
    
    func playSound(soundName: String) {
        guard let path = Bundle.main.path(forResource: soundName, ofType:"mp3") else {
            print("fail to find file")
            return }
        let url = URL(fileURLWithPath: path)

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        let gameCard = cards[indexPath.row]
        if gameCard.isGuessed {
            cell.numberedSlot.image = UIImage(named: "slot\(gameCard.pairId)")
        } else {
            if gameCard.isOpen {
                cell.numberedSlot.image = UIImage(named: "slot\(gameCard.pairId)")
            } else {
                cell.numberedSlot.image = nil
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.viewModel.cardTapped(at: indexPath.row)
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let columns: CGFloat = 4
            // Match spacing below
            let spacing: CGFloat = 5
            let totalHorizontalSpacing = (columns - 1) * spacing

            let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemHeight = (collectionView.bounds.height - totalHorizontalSpacing) / columns
            let gameItemSize = CGSize(width: itemWidth, height: itemHeight)

            return gameItemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // horizontal space between items
            return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // vertical space between lines
            return 5
    }
}

extension ViewController: WinViewDelegateProtocol {
    func newGamgeTapped() {
        viewModel.start()
        viewModel.startNewGame()
    }
    
    func menuTapped() {
        let vc = MainMenuViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
    
    
}

enum Vibration {
        case error
        case success
        case warning
        case light
        case medium
        case heavy
        @available(iOS 13.0, *)
        case soft
        @available(iOS 13.0, *)
        case rigid
        case selection
        case oldSchool

        public func vibrate() {
            switch self {
            case .error:
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            case .success:
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            case .warning:
                UINotificationFeedbackGenerator().notificationOccurred(.warning)
            case .light:
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            case .medium:
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            case .heavy:
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
            case .soft:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                }
            case .rigid:
                if #available(iOS 13.0, *) {
                    UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
                }
            case .selection:
                UISelectionFeedbackGenerator().selectionChanged()
            case .oldSchool:
                print("not implemented")
            }
        }
    }

