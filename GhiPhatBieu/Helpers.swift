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
    private var player2: AVAudioPlayer?
    
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
        play("loadgun.mp3")
    }
    
    func goIn(){
        play("in.mp3")
    }
    func goOut(){
        play("out.mp3")
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
    
    func play(_ base64String: String, speed: Float) {
        if let audioData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters) {
            guard let pl = try? AVAudioPlayer(data: audioData) else {return}
            self.player2 = pl
            self.player2!.enableRate = true
            self.player2!.prepareToPlay()
            self.player2!.rate = speed
            self.player2!.play()
        }
    }
}
