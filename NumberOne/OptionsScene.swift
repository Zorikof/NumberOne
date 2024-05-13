import SpriteKit

class OptionsScene: SKScene {
    
    var musicButton: SKSpriteNode!
    var soundsButton: SKSpriteNode!
    var vibraButton: SKSpriteNode!
    public var music: Bool = true {
        didSet {
            UserDefaults.standard.set(music, forKey: "music")
        }
    }
    public var sound: Bool = true {
        didSet {
            UserDefaults.standard.set(sound, forKey: "sound")
        }
    }
    public var vibra: Bool = true {
        didSet {
            UserDefaults.standard.set(vibra, forKey: "vibra")
        }
    }
    
    override func didMove(to view: SKView) {
        if let savedMusic = UserDefaults.standard.value(forKey: "music") as? Bool {
            music = savedMusic
        }
        if let savedSound = UserDefaults.standard.value(forKey: "sound") as? Bool {
            sound = savedSound
        }
        if let savedVibra = UserDefaults.standard.value(forKey: "vibra") as? Bool {
            vibra = savedVibra
        }
        
        let background = SKSpriteNode(imageNamed: "OptionsBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
        
        let backButton = SKSpriteNode(imageNamed: "BackButton")
        backButton.setScale(1/3)
        backButton.position = CGPoint(x: frame.minX + 60, y: frame.maxY - 60)
        backButton.name = "backButton"
        backButton.zPosition = 1
        addChild(backButton)
        
        let musicLabel = SKSpriteNode(imageNamed: "MusicLabel")
        musicLabel.setScale(0.5)
        musicLabel.position = CGPoint(x: frame.midX - 70, y: frame.midY - 50)
        addChild(musicLabel)
        
        let soundsLabel = SKSpriteNode(imageNamed: "SoundsLabel")
        soundsLabel.setScale(0.5)
        soundsLabel.position = CGPoint(x: frame.midX - 70, y: musicLabel.position.y - 70)
        addChild(soundsLabel)
        
        let vibraLabel = SKSpriteNode(imageNamed: "VibraLabel")
        vibraLabel.setScale(0.5)
        vibraLabel.position = CGPoint(x: frame.midX - 70, y: soundsLabel.position.y - 70)
        addChild(vibraLabel)
        
        let maxWidth = max(musicLabel.size.width, soundsLabel.size.width, vibraLabel.size.width)
        let buttonWidth = SKSpriteNode(imageNamed: "OnButton").size.width
        let buttonOffset: CGFloat = 20
        
        musicButton = SKSpriteNode(imageNamed: "OnButton")
        musicButton.position = CGPoint(x: musicLabel.position.x + maxWidth / 2 + buttonOffset + buttonWidth / 2, y: musicLabel.position.y)
        musicButton.setScale(0.4)
        addChild(musicButton)
        
        soundsButton = SKSpriteNode(imageNamed: "OnButton")
        soundsButton.position = CGPoint(x: soundsLabel.position.x + maxWidth / 2 + buttonOffset + buttonWidth / 2, y: soundsLabel.position.y)
        soundsButton.setScale(0.4)
        addChild(soundsButton)
        
        vibraButton = SKSpriteNode(imageNamed: "OnButton")
        vibraButton.position = CGPoint(x: vibraLabel.position.x + maxWidth / 2 + buttonOffset + buttonWidth / 2, y: vibraLabel.position.y)
        vibraButton.setScale(0.4)
        addChild(vibraButton)
        
        updateButtonTexture(button: musicButton, isEnabled: music)
        updateButtonTexture(button: soundsButton, isEnabled: sound)
        updateButtonTexture(button: vibraButton, isEnabled: vibra)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        
        for node in self.nodes(at: location) {
            if let button = node as? SKSpriteNode {
                if button == musicButton || button == soundsButton || button == vibraButton {
                    switch button {
                    case musicButton:
                        music = !music
                        updateButtonTexture(button: musicButton, isEnabled: music)
                        SoundManager.shared.playButtonSound(named: "Tap")
                    case soundsButton:
                        sound = !sound
                        updateButtonTexture(button: soundsButton, isEnabled: sound)
                        SoundManager.shared.playButtonSound(named: "Tap")
                    case vibraButton:
                        vibra = !vibra
                        updateButtonTexture(button: vibraButton, isEnabled: vibra)
                        SoundManager.shared.playButtonSound(named: "Tap")
                    default:
                        break
                    }
                } else if button.name == "backButton" {
                    if let view = self.view {
                        let transition = SKTransition.fade(withDuration: 0.5)
                        let menuScene = MenuScene(size: view.bounds.size)
                        menuScene.scaleMode = .aspectFill
                        view.presentScene(menuScene, transition: transition)
                    }
                    SoundManager.shared.playButtonSound(named: "Tap")
                }
            }
        }
    }

    func updateButtonTexture(button: SKSpriteNode, isEnabled: Bool) {
        button.texture = isEnabled ? SKTexture(imageNamed: "OnButton") : SKTexture(imageNamed: "OffButton")
    }
}
