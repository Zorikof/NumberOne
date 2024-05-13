import UIKit
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var player: AVAudioPlayer?
    
    private init() { }
    
    func playButtonSound(named name: String) {
        if UserDefaults.standard.bool(forKey: "sound") {
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    
    func playSound(named name: String) {
            if UserDefaults.standard.bool(forKey: "music") {
                guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
                do {
                    player = try AVAudioPlayer(contentsOf: url)
                    player?.numberOfLoops = -1
                    player?.play()
                } catch {
                    print("Error playing sound: \(error.localizedDescription)")
                }
            }
        }
    
    func stopGameSound() {
            player?.stop()
        }
}


class VibrationManager {
    static let shared = VibrationManager()
    
    private let impactFeedbackGenerator: UIImpactFeedbackGenerator
    
    private init() {
        impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        impactFeedbackGenerator.prepare()
    }
    
    func vibrate() {
        if UserDefaults.standard.bool(forKey: "vibra") {
            impactFeedbackGenerator.impactOccurred()
        }
    }
    
    func vibrate(for duration: TimeInterval) {
        if UserDefaults.standard.bool(forKey: "vibra") {
            impactFeedbackGenerator.impactOccurred()
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                self.impactFeedbackGenerator.impactOccurred()
            }
        }
    }
}

