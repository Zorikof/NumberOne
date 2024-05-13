import SpriteKit

class MenuScene: SKScene {
    
    var highScoreLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
                
        let background = SKSpriteNode(imageNamed: "MenuBackground")
        let playButton = SKSpriteNode(imageNamed: "PlayButton")
        let optionsButton = SKSpriteNode(imageNamed: "OptionsButton")
        let recordLabel = SKSpriteNode(imageNamed: "RecordLabel")
        let recordBackground = SKSpriteNode(imageNamed: "RecordBackground")
        highScoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        
        let buttonSize = CGSize(width: 220, height: 78)
        
        playButton.name = "PlayButton"
        optionsButton.name = "OptionsButton"
        
        background.zPosition = -1
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        
        playButton.position = CGPoint(x: size.width / 2, y: size.height / 2)
        optionsButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 100)
        
        background.scale(to: size)
        
        playButton.size = buttonSize
        optionsButton.size = buttonSize
        
        recordLabel.position = CGPoint(x: size.width / 2, y: size.height - 100)
        recordLabel.setScale(0.4)
        
        recordBackground.position = CGPoint(x: size.width / 2, y: size.height - 170)
        recordBackground.setScale(0.4)
        
        highScoreLabel.text = "\(getHighScore())"
        highScoreLabel.position = CGPoint(x: recordBackground.position.x, y: recordBackground.position.y - highScoreLabel.frame.height / 2)
        highScoreLabel.fontColor = .white
        highScoreLabel.fontSize = 36
        
        addChild(recordBackground)
        addChild(recordLabel)
        addChild(background)
        addChild(highScoreLabel)
        addChild(playButton)
        addChild(optionsButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            let location = touch.location(in: self)
            var buttonTapped = false
            let nodes = self.nodes(at: location)
            for node in nodes {
                if !buttonTapped {
                    if let button = node as? SKSpriteNode {
                        SoundManager.shared.playButtonSound(named: "Tap")
                        switch button.name {
                        case "PlayButton":
                            buttonTapped = true
                            if let gameScene = GameScene(fileNamed: "GameScene") {
                                gameScene.scaleMode = .aspectFill
                                view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.5))
                            }
                        case "OptionsButton":
                            buttonTapped = true
                            if let view = self.view {
                                let transition = SKTransition.fade(withDuration: 0.5)
                                let optionsScene = OptionsScene(size: view.bounds.size)
                                optionsScene.scaleMode = .aspectFill
                                view.presentScene(optionsScene, transition: transition)
                            }
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    
    func getHighScore() -> Int {
        let defaults = UserDefaults.standard
        let highScore = defaults.integer(forKey: "HighScore")
        return highScore
    }
}
