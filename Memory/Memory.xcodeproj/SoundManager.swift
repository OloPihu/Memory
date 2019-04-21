//
//  SoundManager.swift
//  Memory
//
//  Created by Aleksander  on 16/04/2019.
//

import Foundation
import AVFoundation

class SoundManager {
    
    static var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect {
        
        case flip
        case shuffle
        case match
        case nomatch
        
        
        
    }
    
    
    
    static func playSound(_ effect:SoundEffect) {
        
        var soundFilename = ""
        
        // okreslenie jakiego dziewku aplikacja bedzie uzywac
        
        switch effect {
            
        case .flip:
            soundFilename = "cardflip"
            
        case .shuffle:
            soundFilename = "shuffle"
            
        case .match:
            soundFilename = "dingcorrect"
            
        case .nomatch:
            soundFilename = "dingwrong"
            
        }
        
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: "wav")
        
        guard bundlePath != nil else {
            print("Couldn't find sound file \(soundFilename) in the bundle")
            return
            
            
        }
        
        let soundURL = URL(fileURLWithPath: bundlePath!)
        do {
            // tworze odtwarzacz audio
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
        }
        catch {
            
            //  wykazanie błedu z audio playerem
            
            print("Couldn't create the audio player object for sound file \(soundFilename)")
            
        }
        
        
    }
    
    
    
    
}






