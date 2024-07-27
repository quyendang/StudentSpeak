//
//  Helpers.swift
//  GhiPhatBieu
//
//  Created by Quyen DanG on 10/07/2024.
//

import Foundation
import AVFoundation


class Helpers: ObservableObject  {
    static let shared = Helpers()
    var bombSoundEffect: AVAudioPlayer?
    
    func upStar() {
        play("tada.mp3")
    }
    
    func success() {
        play("congratulations.mp3")
    }
    
    func downStar() {
        play("down.mp3")
    }
    
    func randomStudent() {
        play("sword.mp3")
    }
    
    private func play(_ sound: String) {
        let path = Bundle.main.path(forResource: sound, ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            bombSoundEffect = try AVAudioPlayer(contentsOf: url)
            bombSoundEffect?.play()
        } catch {
            // couldn't load file :(
        }
    }
}
