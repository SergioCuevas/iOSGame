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
    
    override func didMove(to view: SKView) {
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -18.0)
        
        self.scoreLabel.fontName = "Helvetica"
        self.scoreLabel.fontSize = 60
        self.scoreLabel.text = "0"
        self.scoreLabel.position = CGPoint(x: self.frame.midX, y: 0)
        self.scoreLabel.zPosition = 20
        
        self.addChild(self.scoreLabel)
        
        self.makeBackground()
        
        self.addChild(movingObjects)
        
        let runTexture = SKTexture(imageNamed: "run1.png")
        let runTexture2 = SKTexture(imageNamed: "run2.png")
        let runTexture3 = SKTexture(imageNamed: "run3.png")
        let runTexture4 = SKTexture(imageNamed: "run4.png")
        let runTexture5 = SKTexture(imageNamed: "run5.png")
        let runTexture6 = SKTexture(imageNamed: "run6.png")
        let runTexture7 = SKTexture(imageNamed: "run7.png")
        let runTexture8 = SKTexture(imageNamed: "run8.png")
        let runTexture9 = SKTexture(imageNamed: "run9.png")
        let runTexture10 = SKTexture(imageNamed: "run10.png")
        
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
        
        let ground = SKNode()
        ground.position = CGPoint(x: 0, y: -self.frame.height / 2+80)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.size.width * 2, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = groundGroup
        
        self.addChild(ground)
        
        self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(GameScene.createRocketMan), userInfo: nil, repeats: true)
    }
    

    
    func makeBackground() {
        let bgTexture = SKTexture(imageNamed: "bg.jpg")
        
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
            self.timer = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(GameScene.createRocketMan), userInfo: nil, repeats: true)
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
