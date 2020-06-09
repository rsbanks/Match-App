//
//  SoundManager.swift
//  MatchApp
//
//  Created by Rebecca Banks on 04/06/2020.
//  Copyright © 2020 Rebecca Banks. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager {
    
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEfect {
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEfect) {
        
        var soundFilename = ""
        
        switch effect {
                
            case .flip:
                soundFilename = "cardflip"
            
            case .match:
                soundFilename = "dingcorrect"
            
            case .nomatch:
                soundFilename = "dingwrong"
            
            case .shuffle:
                soundFilename = "shuffle"
            
        }
        
        // Get the path to the resource
        let bundlePath = Bundle.main.path(forResource: soundFilename, ofType: ".wav")
        
        // Check that it is not nil
        guard bundlePath != nil else {
            // Couldn't find the resource, exit
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        do {
            
            // Create the audio player
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            
            // Play the sound effect
            audioPlayer?.play()
        }
        catch {
            print("Couln't create an audio player")
            return
        }
        
    }
    
}
