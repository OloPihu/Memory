//
//  CardModel.swift
//  Memory
//
//  Created by Aleksander  on 09/04/2019.
//


import Foundation


class CardModel {
    
    func getCards() -> [Card] {
        
        // stworzenie tablity dla numerów juz wygenerowanych
        
        var generatedNumbersArray = [Int]()
        
        // tworze tablice do składowania wygenerowanych kart
        var generatedCardArray = [Card]()
        
        // generowanie losowych par kart
        while generatedNumbersArray.count < 8 {
            
            // generowanie losowego numeru dla karty
            
            let randomNumber = arc4random_uniform(13) + 1
            
            // upewnienie sie ze losuje sie numer ktorego nie ma
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
               
                // wyswietlenie w konsoli generowanego numeru
                print(randomNumber)
                
                // składowanie numeru w generatedNumbersArray
                
                generatedNumbersArray.append(Int(randomNumber))
                
                // towrze pierwsza karte (objekt)
                
                let cardOne = Card()
                
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardArray.append(cardOne
                )
                // tworze druga karte (objekt) , potrzebna jest para kart
                
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardArray.append(cardTwo)
                
                // zapewnienie by pary sie nie powtarzały
                
            }
            
            
            
        }
       
        // losowe połozenie kart
        
        for i in 0...generatedCardArray.count {
            
            let randomNumer = Int(arc4random_uniform(UInt32(generatedCardArray.count)))
            
            // mieszanie dwóch kart 
            
            let temporaryStorage = generatedCardArray[0]
            generatedCardArray[0] = generatedCardArray[randomNumer]
            generatedCardArray[randomNumer] = temporaryStorage
        }
            
        
        
        // zwracam watrtosc tablicy
        
        return generatedCardArray
    }
    
}
