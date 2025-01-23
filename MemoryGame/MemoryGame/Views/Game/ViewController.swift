//
//  ViewController.swift
//  MemoryGame
//
//  Created by 8 on 9.08.24.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var movesLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    var viewModel = GameViewModel()
    var cards: [Card] = []
    
    @IBAction func newGameTapped(_ sender: UIButton) {
        // MARK: перезапуск игры
        viewModel.startNewGame()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bindMainState()
        self.bindStepsState()
        self.bindTimerState()
        self.viewModel.start()
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
            case .updateCollection:
                self?.collectionView.reloadData()
            case .gameOver:
                let alert = UIAlertController(title: "You Win!", message: "wow, that's impressive", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
                    alert.dismiss(animated: true)
                })
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func bindStepsState() {
        viewModel.stepsState.bind { [weak self] (newValue) in
            switch newValue {
            case .zeroState:
                self?.movesLabel.text = "0"
            case let .newValue(step):
                self?.movesLabel.text = String(step)
            }
        }
    }
    
    func bindTimerState() {
        viewModel.timerState.bind { [weak self] (newValue) in
            switch newValue {
            case .zeroState:
                self?.timerLabel.text = "00:00"
            case let .newValue(value):
                self?.timerLabel.text = value
            }
        }
    }
    
    func updateTimerLabel() {
//        // MARK: обновление лейбла с временем
//        if let gameTime = game.getGameTime() {
//            timerLabel.text = String(format: "Time: %.0f", gameTime)
//        }
    }
    
    func checkGameOver() {
//        // MARK: проверка не угадал ли уже юзер все пары, и если угадал то алёрт и остановка игры
//        if game.guessedPairs.count == game.pairs.count {
//            timer?.invalidate()
//            let alert = UIAlertController(title: "You Win!", message: "wow, that's impressive", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in
//                alert.dismiss(animated: true)
//            })
//            present(alert, animated: true, completion: nil)
//        }
        }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else { return UICollectionViewCell() }
        // MARK: если ячейка не угадана - показывает "?"
        let gameCard = cards[indexPath.row]
        if gameCard.isGuessed {
            cell.label.text = String(gameCard.pairId)
        } else {
            if gameCard.isOpen {
                cell.label.text = String(gameCard.pairId)
            } else {
                cell.label.text = "?"
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
        let itemSize = CGSize(width: itemWidth, height: itemWidth * 1.2)

        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        // horizontal space between items
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // vertical space between lines
        return 5
    }
}

