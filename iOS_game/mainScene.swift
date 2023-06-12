//
//  MainScene.swift
//  DownStairs
//
//  Created by mac01 on 2023/6/1.
//
//  self.size.width = 393.0

import UIKit
import SpriteKit

class MainScene: SKScene,SKPhysicsContactDelegate {
    
    var highScore: Int = 0
    var goleft = true
    var goright = false
    var point:Int = 0
    var jumpCount = 0
    var bestLabel:  SKLabelNode!
    var scoreLabel: SKLabelNode!
    var mainbgd:    SKSpriteNode!
    var Lwall:      SKSpriteNode!
    var Rwall:      SKSpriteNode!
    var ceiling:    SKSpriteNode!
    var lowerbound: SKSpriteNode!
    var stair:      SKSpriteNode!
    var monster:    SKSpriteNode!
    var spike:      SKSpriteNode!
    var startP:     SKSpriteNode!
    var player:     SKSpriteNode!
    var playerFacing = 1
    var bullet:     SKSpriteNode!
    var P1:         SKSpriteNode!
    var previousX : CGFloat!
    var stairX:     CGFloat!
    var stairGenerator: Timer!
    
     
    override func didMove(to view: SKView) {
        //getBestScore()
        createScene()
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
        //print(self.size.width)
        
        scoreLabel = SKLabelNode()
        scoreLabel.name = "score"
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = .black
        scoreLabel.zPosition = 2
        scoreLabel.fontName = "Copperplate"
        scoreLabel.position = CGPoint(x: self.frame.minX + 80, y: self.frame.maxY - 80)
        scoreLabel.text = "SCORE: \(point)"
        self.addChild(scoreLabel)
        
        
        bestLabel = SKLabelNode()
        bestLabel.name = "score"
        bestLabel.fontSize = 25
        bestLabel.fontColor = .black
        bestLabel.zPosition = 2
        bestLabel.fontName = "Copperplate"
        bestLabel.position = CGPoint(x: self.frame.minX + 80, y: self.frame.maxY - 60)
        bestLabel.text = "BEST: \(highScore)"
        self.addChild(bestLabel)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        firstBody = contact.bodyA
        secondBody = contact.bodyB
        
        if((firstBody.node?.name == "player" && secondBody.node?.name == "stairs") || (firstBody.node?.name == "stairs" && secondBody.node?.name == "player") ){
            point += 1
            jumpCount = 0
            if(point > highScore){
                scoreLabel.text = "SCORE: \(point)"
                bestLabel.text = "BEST: \(point)"
            }else{
                scoreLabel.text = "SCORE: \(point)"
            }
        }else if((firstBody.node?.name == "monster" && secondBody.node?.name == "bullet") || (firstBody.node?.name == "bullet" && secondBody.node?.name == "monster") ){
            contact.bodyA.node?.removeFromParent()
            contact.bodyB.node?.removeFromParent()
            point += 10
            if(point > highScore){
                scoreLabel.text = "SCORE: \(point)"
                bestLabel.text = "BEST: \(point)"
            }else{
                scoreLabel.text = "SCORE: \(point)"
            }
        }else if((firstBody.node?.name == "player" && secondBody.node?.name == "spikes") || (firstBody.node?.name == "spikes" && secondBody.node?.name == "player") ){
            self.physicsWorld.speed = 0
            stairGenerator.invalidate()
            self.isPaused = true
            gameover()
        }else if((firstBody.node?.name == "player" && secondBody.node?.name == "ceiling") || (firstBody.node?.name == "ceiling" && secondBody.node?.name == "player") ){
            stairGenerator.invalidate()
            self.isPaused = true
            gameover()
        }else if((firstBody.node?.name == "player" && secondBody.node?.name == "lowerBound") || (firstBody.node?.name == "lowerBound" && secondBody.node?.name == "player") ){
            stairGenerator.invalidate()
            self.isPaused = true
            gameover()
        }else if((firstBody.node?.name == "player" && secondBody.node?.name == "monster") || (firstBody.node?.name == "monster" && secondBody.node?.name == "player") ){
            stairGenerator.invalidate()
            self.isPaused = true
            gameover()
        }
        
    }
    
    func createScene(){
        mainbgd = SKSpriteNode(imageNamed: "mainbgd")
        mainbgd.size.width = self.size.width
        mainbgd.size.height = self.size.height
        mainbgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mainbgd.zPosition = -1
        self.addChild(mainbgd)
        
        let JumpB = SKSpriteNode(imageNamed: "jumpButton")
        JumpB.name = "jump"
        JumpB.size = CGSize(width: 60, height: 60)
        JumpB.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 140)
        JumpB.zPosition = 1
        self.addChild(JumpB)
        
        let RightB = SKSpriteNode(imageNamed: "rightButton")
        RightB.name = "right"
        RightB.size = CGSize(width: 60, height: 60)
        RightB.position = CGPoint(x: self.frame.midX + 80, y: self.frame.minY + 100)
        RightB.zPosition = 1
        self.addChild(RightB)
        
        let LeftB = SKSpriteNode(imageNamed: "leftButton")
        LeftB.name = "left"
        LeftB.size = CGSize(width: 60, height: 60)
        LeftB.position = CGPoint(x: self.frame.midX - 80, y: self.frame.minY + 100)
        LeftB.zPosition = 1
        self.addChild(LeftB)
        
        let shootB = SKSpriteNode(imageNamed: "shoot")
        shootB.name = "shoot"
        shootB.size = CGSize(width: 60, height: 60)
        shootB.position = CGPoint(x: self.frame.midX, y: self.frame.minY + 60)
        shootB.zPosition = 1
        self.addChild(shootB)
        
        createWall()
        startPlatform()
        P1 = createPlayer()
        self.addChild(P1)
        
        stairGenerator = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(newStep), userInfo: nil, repeats: true)
        //spikeGenerator = Timer.scheduledTimer(timeInterval: 6.7, target: self, selector: #selector(newSpike), userInfo: nil, repeats: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchnode = atPoint(location)
            if touchnode.name == "jump" && jumpCount <= 2{
                let jump = SKAction.moveBy(x: 0, y: 150, duration: 0.3)
                P1.run(jump)
                jumpCount += 1
            }
            else if touchnode.name == "right"{
                let right = SKAction.moveBy(x: 500, y: 0, duration: 2.5)
                if(goleft){
                    P1.removeAction(forKey: "left")
                    goleft = false
                }
                playerFacing = 1
                goright = true
                P1.run(right, withKey: "right")
            }
            else if touchnode.name == "left"{
                let left = SKAction.moveBy(x: -500, y: 0, duration: 2.5)
                if(goright){
                    P1.removeAction(forKey: "right")
                    goright = false
                }
                playerFacing = 0
                goleft = true
                P1.run(left, withKey: "left")
            }
            else if touchnode.name == "shoot" && playerFacing == 1{
                rBullet(player)
            }
            else if touchnode.name == "shoot" && playerFacing == 0{
                lBullet(player)
            }
        }
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(goright){
            P1.removeAction(forKey: "right")
            goright = false
        }
        else if (goleft){
            P1.removeAction(forKey: "left")
            goleft = false
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(goright){
            P1.removeAction(forKey: "right")
            goright = false
        }
        else if (goleft){
            P1.removeAction(forKey: "left")
            goleft = false
        }
    }
    
    @objc func newStep(){
        let randNum = Int(arc4random() % 100)
        if(point > 100){
            if(randNum > 75){
                newSpike()
            }else if randNum < 20{
                newStair()
                newMonster()
            }else{
                newStair()
            }
        }else if(point > 50){
            if(randNum > 80){
                newSpike()
            }else if randNum < 15{
                newStair()
                newMonster()
            }else{
                newStair()
            }
        }else{
            if(randNum > 85){
                newSpike()
            }else if randNum < 10{
                newStair()
                newMonster()
            }else{
                newStair()
            }
        }
    }
    
    func startPlatform(){
        startP = SKSpriteNode(imageNamed: "normal")
        startP.size = CGSize(width: 150, height: 20)
        let remove = SKAction.sequence([SKAction.moveTo(y: self.size.height + 250, duration: 7),SKAction.removeFromParent()])
        startP.position = CGPoint(x: self.size.width/2, y: 100)
        previousX = self.size.width / 2
        startP.name = "start"
        startP.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 150, height: 20))
        startP.physicsBody?.usesPreciseCollisionDetection = true
        startP.physicsBody?.isDynamic = false
        startP.physicsBody?.categoryBitMask = 0x1 << 4
        startP.physicsBody?.contactTestBitMask = 0x1 << 1
        startP.physicsBody?.collisionBitMask = 0x1 << 1
        startP.run(remove)
        self.addChild(startP)
    }
    
    func createPlayer()->SKSpriteNode{
        player = SKSpriteNode(imageNamed: "player")
        player.size = CGSize(width: 25, height: 30)
        player.position = CGPoint(x: self.size.width/2, y: 130)
        
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 25, height: 30))
        player.physicsBody?.usesPreciseCollisionDetection = true
        player.physicsBody?.restitution = 0
        player.physicsBody?.allowsRotation = false
        
        let mask = UInt32.max
        player.physicsBody?.categoryBitMask = 0x1 << 1
        player.physicsBody?.contactTestBitMask = mask
        player.physicsBody?.collisionBitMask = mask
        
        player.name = "player"
        
        return player
    }
    
    func rBullet(_ player: SKSpriteNode){
        bullet = SKSpriteNode(imageNamed: "fire")
        bullet.size = CGSize(width: 10, height: 10)
        bullet.position = CGPoint(x: player.position.x, y: player.position.y + 20)
        let move = SKAction.moveTo(x: self.frame.maxX + 40, duration: 1.0)
        let remove = SKAction.removeFromParent()
        let shoot = SKAction.sequence([move,remove])
        bullet.run(shoot)
        bullet.name = "bullet"
        self.addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = 0x1 << 10
        bullet.physicsBody?.contactTestBitMask = 0x1 << 9
        bullet.physicsBody?.collisionBitMask = 0x1 << 9
        
    }
    
    func lBullet(_ player: SKSpriteNode){
        bullet = SKSpriteNode(imageNamed: "fire")
        bullet.size = CGSize(width: 10, height: 10)
        bullet.position = CGPoint(x: player.position.x, y: player.position.y + 20)
        let move = SKAction.moveTo(x: self.frame.minX - 40, duration: 1.0)
        let remove = SKAction.removeFromParent()
        let shoot = SKAction.sequence([move,remove])
        bullet.run(shoot)
        bullet.name = "bullet"
        self.addChild(bullet)
        bullet.physicsBody = SKPhysicsBody(circleOfRadius: 5)
        bullet.physicsBody?.usesPreciseCollisionDetection = true
        bullet.physicsBody?.affectedByGravity = false
        bullet.physicsBody?.categoryBitMask = 0x1 << 10
        bullet.physicsBody?.contactTestBitMask = 0x1 << 9
        bullet.physicsBody?.collisionBitMask = 0x1 << 9
        
    }
    
    func createWall(){
        Lwall = SKSpriteNode(imageNamed: "wall")
        Lwall.size.width = 20;
        Lwall.size.height = self.size.height
        Lwall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: self.size.height))
        Lwall.physicsBody?.isDynamic = false
        Lwall.physicsBody?.usesPreciseCollisionDetection = true
        Lwall.physicsBody?.categoryBitMask = 0x1 << 5
        Lwall.physicsBody?.contactTestBitMask = 0x1 << 1
        Lwall.physicsBody?.collisionBitMask = 0x1 << 1
        Lwall.position = CGPoint(x: 10 , y: self.size.height/2)
        Lwall.zPosition = 1
        self.addChild(Lwall)
        
        Rwall = SKSpriteNode(imageNamed: "wall")
        Rwall.size.width = 20;
        Rwall.size.height = self.size.height
        Rwall.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 20, height: self.size.height))
        Rwall.physicsBody?.usesPreciseCollisionDetection = true
        Rwall.physicsBody?.isDynamic = false
        Rwall.physicsBody?.categoryBitMask = 0x1 << 6
        Rwall.physicsBody?.contactTestBitMask = 0x1 << 1
        Rwall.physicsBody?.collisionBitMask = 0x1 << 1
        Rwall.position = CGPoint(x: self.size.width - 10, y: self.size.height/2)
        Rwall.zPosition = 1
        self.addChild(Rwall)
        
        ceiling = SKSpriteNode(imageNamed: "ceiling")
        ceiling.size.width = self.size.width
        ceiling.size.height = 30;
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 30))
        ceiling.name = "ceiling"
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.usesPreciseCollisionDetection = true
        ceiling.physicsBody?.categoryBitMask = 0x1 << 7
        ceiling.physicsBody?.contactTestBitMask = 0x1 << 1
        ceiling.physicsBody?.collisionBitMask = 0x1 << 1
        ceiling.position = CGPoint(x: self.size.width/2, y: self.size.height - 15)
        ceiling.zPosition = 1
        self.addChild(ceiling)
        
        lowerbound = SKSpriteNode(imageNamed: "ceiling")
        lowerbound.size.width = self.size.width
        lowerbound.size.height = 20;
        lowerbound.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 20))
        lowerbound.name = "lowerBound"
        lowerbound.physicsBody?.isDynamic = false
        lowerbound.physicsBody?.usesPreciseCollisionDetection = true
        lowerbound.physicsBody?.categoryBitMask = 0x1 << 8
        lowerbound.physicsBody?.contactTestBitMask = 0x1 << 1
        lowerbound.physicsBody?.collisionBitMask = 0x1 << 1
        lowerbound.position = CGPoint(x: self.frame.midX, y: self.frame.minY-40)
        lowerbound.yScale = -1
        lowerbound.zPosition = 1
        self.addChild(lowerbound)
    }
    
    func newStair(){
        stair = SKSpriteNode(imageNamed: "normal")
        stair.size = CGSize(width: 100, height: 20)
        let w = self.size.width - 140
        stairX = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        while abs(previousX-stairX) < 40{
            stairX = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        }
        stair.position = CGPoint(x: stairX, y: 0)
        previousX = stairX
        stair.name = "stairs"
        let remove = SKAction.sequence([SKAction.moveTo(y: self.size.height + 150, duration: 7),SKAction.removeFromParent()])
        stair.run(remove)
        
        stair.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 20))
        stair.physicsBody?.usesPreciseCollisionDetection = true
        stair.physicsBody?.isDynamic = false
        stair.physicsBody?.categoryBitMask = 0x1 << 2
        stair.physicsBody?.contactTestBitMask = 0x1 << 1 | 0x1 << 9
        stair.physicsBody?.collisionBitMask = 0x1 << 1 | 0x1 << 9
        
        self.addChild(stair)
    }
    
    func newMonster(){
        monster = SKSpriteNode(imageNamed: "monster")
        monster.size = CGSize(width: 35, height: 45)
        monster.position = CGPoint(x: stairX, y: 15)
        monster.name = "monster"
        let remove = SKAction.sequence([SKAction.wait(forDuration: 7),SKAction.removeFromParent()])
        monster.run(remove)
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 35, height: 40))
        monster.physicsBody?.usesPreciseCollisionDetection = true
        monster.physicsBody?.restitution = 0
        monster.physicsBody?.allowsRotation = false
        
        let mask = UInt32.max
        monster.physicsBody?.categoryBitMask = 0x1 << 9
        monster.physicsBody?.contactTestBitMask = mask
        monster.physicsBody?.collisionBitMask = mask
        self.addChild(monster)
    }
    
    func newSpike(){
        spike = SKSpriteNode(imageNamed: "spike")
        spike.size = CGSize(width: 60, height: 30)
        let w = self.size.width - 140
        var x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        while abs(previousX-x) < 40{
            x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        }
        spike.position = CGPoint(x: x, y: 0)
        previousX = x
        spike.name = "spikes"
        let remove = SKAction.sequence([SKAction.moveTo(y: self.size.height + 150, duration: 7),SKAction.removeFromParent()])
        spike.run(remove)
        
        spike.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 60, height: 30))
        spike.physicsBody?.usesPreciseCollisionDetection = true
        spike.physicsBody?.isDynamic = false
        spike.physicsBody?.categoryBitMask = 0x1 << 3
        spike.physicsBody?.contactTestBitMask = 0x1 << 1
        spike.physicsBody?.collisionBitMask = 0x1 << 1
        
        self.addChild(spike)
        
    }
    
   
    
        
    func gameover(){
        let endScene = endScene(size: self.size)
        let trans = SKTransition.fade(withDuration: 5)
        endScene.point = point
        endScene.highScore = self.highScore
        //let Data = Score(highscore: self.highScore)
        //self.setBestScore(data: Data)
        self.view?.presentScene(endScene,transition: trans)
        
    }
    
}
