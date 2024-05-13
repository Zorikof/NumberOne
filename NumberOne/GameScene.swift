import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var player: SKSpriteNode!
    private var scoreLabel: SKLabelNode!
    private var score = 0
    private var gameOver = false
    private var collisionOccurred = false
    private var isGamePaused = false
    private var pauseButton = SKSpriteNode(imageNamed: "PauseButton")
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        physicsWorld.contactDelegate = self
        
        addBackground()
        addBackButton()
        addPlayer()
        addScoreLabel()
        setupPauseButton()
        
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(createObstacle), SKAction.wait(forDuration: 0.85)])))
        
        SoundManager.shared.playSound(named: "Game")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !collisionOccurred else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        
        if let node = self.nodes(at: touchLocation).first as? SKSpriteNode {
            if node.name == "pauseButton" {
                togglePause()
            } else if node.name == "backButton" {
                returnToMenu()
                SoundManager.shared.stopGameSound()
            }
        } else {
            player.position.x = touchLocation.x
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard !collisionOccurred else { return }
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        player.position.x = touchLocation.x
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == 1 && contact.bodyB.categoryBitMask == 2) ||
            (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1) {
            if !gameOver {
                endGame()
            }
        }
    }
    
    func createObstacle() {
        guard !gameOver else { return }
        
        let obstacle = SKSpriteNode(imageNamed: "Star")
        obstacle.setScale(0.5)
        obstacle.position = CGPoint(x: CGFloat.random(in: frame.minX...frame.maxX), y: frame.maxY)
        addChild(obstacle)
        
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: obstacle.size.width / 3, height: obstacle.size.height / 3))
        obstacle.physicsBody?.categoryBitMask = 2
        obstacle.physicsBody?.collisionBitMask = 0
        obstacle.physicsBody?.contactTestBitMask = 1
        
        let decreasedDuration = calculateObstacleDuration()
        let moveAction = SKAction.moveTo(y: frame.minY, duration: decreasedDuration)
        let removeAction = SKAction.removeFromParent()
        let sequence = SKAction.sequence([moveAction, removeAction])
        obstacle.run(sequence) {
            guard !self.gameOver else { return }
            self.score += 1
            self.updateScoreLabel()
            if self.score % 15 == 0 {
                self.updateObstacleSpeed()
            }
        }
    }

    func calculateObstacleDuration() -> TimeInterval {
        let initialDuration: TimeInterval = 3
        let decreaseCoefficient = pow(0.9, Double(score / 15))
        let decreasedDuration = initialDuration * decreaseCoefficient
        return decreasedDuration
    }
    
    private func endGame() {
        VibrationManager.shared.vibrate(for: 1.0)
        gameOver = true
        collisionOccurred = true
        removeAllActions()
        enumerateChildNodes(withName: "obstacle") { node, _ in
            node.removeAllActions()
        }
        showGameOverScene()
    }
    
    private func addBackground() {
        let background = SKSpriteNode(imageNamed: "GameBackground")
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        background.zPosition = -1
        addChild(background)
    }
    
    private func addBackButton() {
        let backButton = SKSpriteNode(imageNamed: "BackButton")
        backButton.setScale(0.5)
        backButton.position = CGPoint(x: frame.minX + 170, y: frame.maxY - 100)
        backButton.name = "backButton"
        backButton.zPosition = 1
        addChild(backButton)
    }
    
    private func addPlayer() {
        player = SKSpriteNode(imageNamed: "Crab")
        player.setScale(0.5)
        player.position = CGPoint(x: frame.midX, y: frame.minY + 100)
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.categoryBitMask = 1
        player.physicsBody?.collisionBitMask = 0
        player.physicsBody?.contactTestBitMask = 2
        player.physicsBody?.affectedByGravity = false
    }
    
    private func addScoreLabel() {
        scoreLabel = SKLabelNode(fontNamed: "Arial-BoldMT")
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 150)
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
    }
    
    private func setupPauseButton() {
        pauseButton.setScale(0.5)
        pauseButton.position = CGPoint(x: frame.maxX - 170, y: frame.maxY - 100)
        pauseButton.name = "pauseButton"
        pauseButton.texture = SKTexture(imageNamed: "PauseButton")
        pauseButton.zPosition = 1
        addChild(pauseButton)
    }
    
    func togglePause() {
        isGamePaused.toggle()
        if isGamePaused {
            isPaused = true
            pauseButton.texture = SKTexture(imageNamed: "Resume")
        } else {
            isPaused = false
            pauseButton.texture = SKTexture(imageNamed: "PauseButton")
            
        }
    }
    
    private func updateScoreLabel() {
        scoreLabel.text = "\(score)"
    }
    
    private func returnToMenu() {
        
        let defaults = UserDefaults.standard
        let previousRecord = defaults.integer(forKey: "HighScore")
        if score > previousRecord {
            defaults.set(score, forKey: "HighScore")
        }
        
        if let view = self.view {
            let transition = SKTransition.fade(withDuration: 0.5)
            let menuScene = MenuScene(size: view.bounds.size)
            menuScene.scaleMode = .aspectFill
            view.presentScene(menuScene, transition: transition)
        }
    }
    
    private func showGameOverScene() {
        if let view = self.view {
            let transition = SKTransition.fade(withDuration: 0.5)
            let gameOverScene = GameOverScene(size: view.bounds.size)
            gameOverScene.scaleMode = .aspectFill
            gameOverScene.finalScore = score
            view.presentScene(gameOverScene, transition: transition)
        }
    }
    
    func updateObstacleSpeed() {
        let decreasedDuration = calculateObstacleDuration()
        
        enumerateChildNodes(withName: "obstacle") { node, _ in
            if let obstacle = node as? SKSpriteNode {
                let moveAction = SKAction.moveTo(y: self.frame.minY, duration: decreasedDuration)
                obstacle.removeAllActions()
                obstacle.run(moveAction)
            }
        }
    }
}
