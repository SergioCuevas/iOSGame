//
//  GameScene.swift
//  Flappy Bird
//
//  Stucom
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var saltando = 0;
    var run = SKSpriteNode()
    var bg = SKSpriteNode()
    var movingObjects = SKNode()
    var intervalT = 10
    var gameOver = false
    
    

    var timer = Timer()
    
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    
    let birdGroup:UInt32 = 1
    let objectGroup:UInt32 = 2
    let groundGroup:UInt32 = 3
    let gapGroup:UInt32 = 1 << 2
    
    var bananas = SKSpriteNode()
    let fruitGroup: UInt32 = 4
    var personaje = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -50.0)
        
        self.scoreLabel.fontName = "Helvetica"
        self.scoreLabel.fontSize = 60
        self.scoreLabel.text = "0"
        self.scoreLabel.position = CGPoint(x: self.frame.midX, y: 0)
        self.scoreLabel.zPosition = 20
        
        self.addChild(self.scoreLabel)
        
        self.makeBackground()
        
        self.addChild(movingObjects)
        
        let runTexture = SKTexture(imageNamed: "0.gif")
        let runTexture2 = SKTexture(imageNamed: "1.gif")
        let runTexture3 = SKTexture(imageNamed: "2.gif")
        let runTexture4 = SKTexture(imageNamed: "3.gif")
        let runTexture5 = SKTexture(imageNamed: "4.gif")
        let runTexture6 = SKTexture(imageNamed: "5.gif")
        let runTexture7 = SKTexture(imageNamed: "6.gif")
        let runTexture8 = SKTexture(imageNamed: "7.gif")
        let runTexture9 = SKTexture(imageNamed: "8.gif")
        let runTexture10 = SKTexture(imageNamed: "9.gif")
        
        let animation = SKAction.animate(with: [runTexture, runTexture2, runTexture3, runTexture4, runTexture5, runTexture6, runTexture7, runTexture8, runTexture9, runTexture10], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatForever(animation)
        
        run = SKSpriteNode(texture: runTexture)
        run.position = CGPoint(x: -self.frame.width/2+self.frame.width/5, y: self.frame.midY-50)
        
        run.zPosition = 10
        
        run.run(makeBirdFlap)
        
        run.physicsBody = SKPhysicsBody(circleOfRadius: run.size.width / 2)
        run.physicsBody?.isDynamic = true
        run.physicsBody?.allowsRotation = false
        run.physicsBody?.categoryBitMask = birdGroup
        run.physicsBody?.collisionBitMask = objectGroup
        run.physicsBody?.contactTestBitMask = objectGroup | gapGroup
        
        self.addChild(run)
        for _ in  1...5{
            self.createEnemies()
        }
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: -self.frame.height / 2+80)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 2, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        
        self.addChild(ground)
        
      self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(GameScene.createEnemies), userInfo: nil, repeats: true)    }
    

    
    func makeBackground() {
        let bgTexture = SKTexture(imageNamed: "SpriteBackGround.png")
        let moveBg = SKAction.moveBy(x: -bgTexture.size().width*2, y: 0, duration: 9)
        let replaceBg = SKAction.moveBy(x: bgTexture.size().width*2, y: 0, duration: 0)
        let moveBgForever = SKAction.repeatForever(SKAction.sequence([moveBg, replaceBg]))
        
        for i in 0 ..< 3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: (0) + (bgTexture.size().width * CGFloat(i)), y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.run(moveBgForever)
            
            self.movingObjects.addChild(bg)
        }

    }
    
    func createEnemies() {
        let gapHeight = run.size.height * 4
        let movementAmount = arc4random_uniform(UInt32(self.frame.size.height / 2))
        let rocketManOffset = CGFloat(movementAmount) - self.frame.size.height / 4
        
        let EnemyTexture = SKTexture(imageNamed: "frames-4/1.gif")
        let EnemyTexture1 = SKTexture(imageNamed: "frames-4/2.gif")
        let EnemyTexture2 = SKTexture(imageNamed: "frames-4/3.gif")
        let EnemyTexture3 = SKTexture(imageNamed: "frames-4/4.gif")
        let EnemyTexture4 = SKTexture(imageNamed: "frames-4/5.gif")
        let EnemyTexture5 = SKTexture(imageNamed: "frames-4/6.gif")
        let EnemyTexture6 = SKTexture(imageNamed: "frames-4/7.gif")

        let animationEnemy = SKAction.animate(with: [EnemyTexture, EnemyTexture1, EnemyTexture2, EnemyTexture3, EnemyTexture4, EnemyTexture5,EnemyTexture6], timePerFrame: 0.1)
        let EnemyMove = SKAction.repeatForever(animationEnemy)
        
        
        let moveRocketMan = SKAction.moveBy(x: -(self.frame.size.width + (EnemyTexture.size().width * 2)), y: 0, duration: TimeInterval(self.frame.size.width / 200))
        let removeRocketMan = SKAction.removeFromParent()
        let moveAndRemoveRocketMan = SKAction.sequence([animationEnemy,moveRocketMan, removeRocketMan])
        
        
        let rocketMan = SKSpriteNode(texture: EnemyTexture)
        rocketMan.position = CGPoint(x: self.frame.width, y: -self.frame.height/3)
        rocketMan.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: EnemyTexture.size().width, height: EnemyTexture.size().height))
        rocketMan.physicsBody?.isDynamic = false
        rocketMan.physicsBody?.categoryBitMask = objectGroup
        
        rocketMan.run(moveAndRemoveRocketMan)
        
        self.movingObjects.addChild(rocketMan)
        
        let gap = SKNode()
        gap.position = CGPoint(x: self.frame.size.width + EnemyTexture.size().width, y: (-self.frame.height/2)+EnemyTexture.size().height/2)
        gap.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rocketMan.size.width, height: self.frame.height+((-self.frame.height/3)+EnemyTexture.size().height/2)))
        gap.physicsBody?.isDynamic = false
        
        gap.physicsBody?.categoryBitMask = gapGroup
        
        gap.run(moveAndRemoveRocketMan)
        
        gap.zPosition = 30
        
        self.movingObjects.addChild(gap)
    }
    
    
    func BananasCoins() {
        
        let AppleTexture = SKTexture(imageNamed: "Banana.png")
        bananas = SKSpriteNode(texture: AppleTexture)
        let randomNum:UInt32 = arc4random_uniform(3000)
        let randomNum2:UInt32 = arc4random_uniform(600)
        
        bananas.position = CGPoint(x: CGFloat(randomNum) , y: CGFloat(randomNum2) + 200)
        bananas.physicsBody?.allowsRotation = false
        bananas.physicsBody = SKPhysicsBody(circleOfRadius: bananas.size.width / 2)
        bananas.physicsBody?.isDynamic = false
        bananas.zPosition = 101
        bananas.physicsBody?.categoryBitMask = fruitGroup
        self.addChild(bananas)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == gapGroup || contact.bodyB.categoryBitMask == gapGroup {
            score += 1
            self.scoreLabel.text = "\(score)"
        }else if(contact.bodyA.categoryBitMask == groundGroup || contact.bodyB.categoryBitMask == groundGroup){
            saltando = 0
        }
        else if !gameOver {
            self.gameOver = true
            self.movingObjects.speed = 0
            timer.invalidate()
            
            self.gameOverLabel.fontName = "Helvetica"
            self.gameOverLabel.fontSize = 30
            self.gameOverLabel.text = "Toca para intentarlo de nuevo"
            self.gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
            self.gameOverLabel.zPosition = 20
            
            self.addChild(self.gameOverLabel)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameOver {
            if(saltando == 0){
                run.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                run.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3000))
                saltando+=1
            }
            else if(saltando == 1){
                run.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                run.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 3000))
                saltando+=1
            }
        }
        else {
            score = 0
            scoreLabel.text = "0"
            movingObjects.removeAllChildren()
            makeBackground()
            self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(GameScene.createEnemies), userInfo: nil, repeats: true)
            run.position = CGPoint(x: -self.frame.width/2+self.frame.width/5, y: self.frame.midY-50)
            run.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            self.gameOverLabel.removeFromParent()
            self.movingObjects.speed = 1
            
            gameOver = false
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
}
