//
//  CardCollectionViewCell.swift
//  Memory
//
//  Created by Aleksander  on 11/04/2019.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    
    @IBOutlet weak var backImageView: UIImageView!
    
    
    var card:Card?
    
    // obracanie kart
    
    func setCard(_ card:Card) {
        
        self.card = card
        
        if card.isMatched == true {
            
            // ukrycie image view przy parowaniu
            backImageView.alpha = 0
            frontImageView.alpha = 0
            
            return
        }
        else {
            
            // zapobieganie ukrywania image view przy braku pary
            
            backImageView.alpha = 1
            frontImageView.alpha = 1
            
        }
        
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // okreslenie czy karta jest odwrócona koszulka czy góra
        
        if card.isFlipped == true {
            
            // frontimageview jest odsłoniete
            
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        }
            
        else {
            
            // back imageview jest odsłoniete
            
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
            
        }
    }
    
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.4, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            
        }
        
    }
    
    func remove() {
        
        // usuwa obie sparowane karty
        backImageView.alpha = 0
        
        // animacja
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            
            self.frontImageView.alpha = 0
            
            }, completion: nil)
        
        
        
        
    }
}
