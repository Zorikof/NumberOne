import SpriteKit

class GameOverScene: SKScene {
    
    var finalScore: Int = 0
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "GameOverSceneBackground")
        let againButton = SKSpriteNode(imageNamed: "AgainButton")
        let menuButton = SKSpriteNode(imageNamed: "MenuButton")
        let scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        
        background.scale(to: size)
        background.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
        background.zPosition = -1
        
        scoreLabel.text = "\(finalScore)"
        scoreLabel.position = CGPoint(x: size.width / 2, y: size.height / 2 + 150)
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 48
        
        let buttonSize = CGSize(width: 220, height: 78)
        let verticalSpacing: CGFloat = 100
        
        againButton.name = "AgainButton"
        menuButton.name = "MenuButton"
        againButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - 50)
        menuButton.position = CGPoint(x: size.width / 2, y: size.height / 2 - verticalSpacing - 50)
        againButton.size = buttonSize
        menuButton.size = buttonSize
        
        addChild(background)
        addChild(scoreLabel)
        addChild(againButton)
        addChild(menuButton)
        
        let defaults = UserDefaults.standard
        let previousRecord = defaults.integer(forKey: "HighScore")
        if finalScore > previousRecord {
            defaults.set(finalScore, forKey: "HighScore")
        }
        
        SoundManager.shared.stopGameSound()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let nodes = self.nodes(at: location)
            for node in nodes {
                if let button = node as? SKSpriteNode {
                    switch button.name {
                    case "AgainButton":
                        restartGame()
                        SoundManager.shared.playButtonSound(named: "Tap")
                    case "MenuButton":
                        returnToMenu()
                        SoundManager.shared.playButtonSound(named: "Tap")
                    default:
                        break
                    }
                }
            }
        }
    }
    
    func restartGame() {
        if let gameScene = GameScene(fileNamed: "GameScene") {
            gameScene.scaleMode = .aspectFill
            view?.presentScene(gameScene, transition: .crossFade(withDuration: 0.5))
        }
    }
    
    func returnToMenu() {
        if let view = self.view {
            let transition = SKTransition.fade(withDuration: 0.5)
            let menuScene = MenuScene(size: view.bounds.size)
            menuScene.scaleMode = .aspectFill
            view.presentScene(menuScene, transition: transition)
        }
    }
}
