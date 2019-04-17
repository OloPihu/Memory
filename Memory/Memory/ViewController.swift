//
//  ViewController.swift
//  Memory
//
//  Created by Aleksander  on 09/04/2019.
//
// aplikacje tworzona w cyklu nauki z kursem internetowym CodeWithCris

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var miliseconds:Float = 45 * 1000
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // uzycie metody z card model
        
        cardArray = model.getCards()
        // tworze licznik czasu
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerElapsed), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // okreslenie rozmiaru komórki
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        let width = self.collectionView.frame.size.width
        let itemWidth = (width - (10*3))/4
        let itemHeight = itemWidth * 1.4177
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        SoundManager.playSound(.shuffle)
    }
    
    @objc func timerElapsed() {
        
        miliseconds -= 1
        
        // zamiana na sekundy
        
        let seconds =  String(format: "%.2f", miliseconds/1000)
        
        // ustawienie etykiety
        
        timerLabel.text = "Time Remaining: \(seconds)"
        
        // zatrzymanie zegara na 0
        
        if miliseconds <= 0 {
            
            // zatrzymanie zegara
            
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // sprawdzenie czy po zatrzymaniu zegara pozotały jakiekolwiek niesparowane karty
            
            checkGameEnded()
            
        }
    }
    
    
    
    
    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cardArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // przekierowaniue do cardcollectionviewcell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // okreslenie karty która collection view chce wyswietlic
        
        let card = cardArray[indexPath.row]
        
        // przypisanie tej karty do komórki
        
        cell.setCard(card)
        
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // sprawdzenie czy pozostał czas, uniemozliwienie dalszej gry po alercie koncowym 
        if miliseconds <= 0 {
            
            return
            
        }
        
        // oznaczenie komórki wybranej przez uzytkownika
        
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // oznaczenie karty wybranej przez uzytkownika
        
        let card = cardArray[indexPath.row]
        
        // problem z obracaniem obróconej karty
        
        if card.isFlipped == false && card.isMatched == false {
            
            // obrócenie karty
            
            cell.flip()
            
            // odtwarzanie dzwieku obracania karty
            SoundManager.playSound(.flip)
            
            // aktualizacja statusu obrotu karty
            
            card.isFlipped = true
            
            // okreslenie czy została odwrócona pierwsza czy druga karta
            
            if firstFlippedCardIndex == nil {
                
                //pierwsza odwrócona karta
                
                firstFlippedCardIndex = indexPath
                
            }
            else {
                
                // druga odsłonieta karta
                
                
                // logika łaczenia kart
                checkForMataches(indexPath)
                
                
            }
        }
        
        
        
    }
    
    func checkForMataches(_ secondFlippedCardIndex:IndexPath) {
        
        //
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // tworze dwie karty z tych odkrytych
        
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // porównanie dwóch kart by je połaczyc
        
        if cardOne.imageName == cardTwo.imageName {
            
            // sa takie same
            
            SoundManager.playSound(.match)
            
            // zmiana statusu karty
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // usuniecie karty
            
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // powyżej uzywam  optional chaining by uniknać błędu aplikacji
            
            // sprawdzenie czy pozostały niesparowane karty
            checkGameEnded()
        }
        else {
            
            // nie sa takie same
            
            SoundManager.playSound(.nomatch)
            
            // status karty
            
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // odwrócenie kart koszulkami do góry
            
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
            
        }
        
        // nakazanie collectionview ponowne załadowanie konórki pierwszej karty jezeli spełnia sie nil
        
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        
        firstFlippedCardIndex = nil
        
    }
    
    func checkGameEnded() {
        
        // okreslenie czy zostały karty
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                
                isWon = false
                break
            }
        }
        // zmienne w wiadomosciach
        var title = ""
        var message = ""
        
        // jak tak to uzytkownik wygrał
        
        if isWon ==  true {
            
            if miliseconds > 0 {
                
                timer?.invalidate()
                
            }
            title = "Congratulations!"
            message = "You've won"
        }
        else {
            
            // jezli zostały jakiekolwiek karty pierw kontrola czy został czas
            if miliseconds > 0 {
                return
            }
            title = "Game Over"
            message = "You've lost"
            
        }
        
        
        // wiadomosc na wygrana lub przegrana
        showAlert(title, message)
        
        
        
    }
    
    func showAlert(_ title:String, _ message:String) {
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
