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
    
    var mainbgd: SKSpriteNode!
    var Lwall: SKSpriteNode!
    var Rwall: SKSpriteNode!
    var ceiling: SKSpriteNode!
    var stair: SKSpriteNode!
    var spike: SKSpriteNode!
    var stairGenerator: Timer!
    var startP: SKSpriteNode!
    var previousX : CGFloat!
    var player: SKSpriteNode!
    var P1: SKSpriteNode!
    var goleft = true
    var goright = false
    var point = 0
    
     
    override func didMove(to view: SKView) {
        createScene()
        physicsWorld.gravity = CGVector(dx: 0, dy: -2.0)
        //print(self.size.width)
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
            if touchnode.name == "jump"{
                let jump = SKAction.moveBy(x: 0, y: 150, duration: 0.3)
                P1.run(jump)
            }
            else if touchnode.name == "right"{
                let right = SKAction.moveBy(x: 100, y: 0, duration: 0.5)
                if(goleft){
                    P1.removeAction(forKey: "left")
                    goleft = false
                }
                goright = true
                P1.run(right, withKey: "right")
            }
            else if touchnode.name == "left"{
                let left = SKAction.moveBy(x: -100, y: 0, duration: 0.5)
                if(goright){
                    P1.removeAction(forKey: "right")
                    goright = false
                }
                goleft = true
                P1.run(left, withKey: "left")
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
        if(randNum > 85){
            newSpike()
        }else{
            newStair()
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
        player.size = CGSize(width: 20, height: 20)
        player.position = CGPoint(x: self.size.width/2, y: 130)
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width/2)
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
        ceiling.size.height = 20;
        ceiling.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 20))
        ceiling.name = "ceiling"
        ceiling.physicsBody?.isDynamic = false
        ceiling.physicsBody?.usesPreciseCollisionDetection = true
        ceiling.physicsBody?.categoryBitMask = 0x1 << 7
        ceiling.physicsBody?.contactTestBitMask = 0x1 << 1
        ceiling.physicsBody?.collisionBitMask = 0x1 << 1
        ceiling.position = CGPoint(x: self.size.width/2, y: self.size.height - 10)
        ceiling.zPosition = 1
        self.addChild(ceiling)
    }
    
    func newStair(){
        stair = SKSpriteNode(imageNamed: "normal")
        stair.size = CGSize(width: 100, height: 20)
        let w = self.size.width - 140
        var x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        while abs(previousX-x) < 40{
            x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        }
        stair.position = CGPoint(x: x, y: 0)
        previousX = x
        stair.name = "stairs"
        let remove = SKAction.sequence([SKAction.moveTo(y: self.size.height + 150, duration: 7),SKAction.removeFromParent()])
        stair.run(remove)
        
        stair.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 20))
        stair.physicsBody?.usesPreciseCollisionDetection = true
        stair.physicsBody?.isDynamic = false
        stair.physicsBody?.categoryBitMask = 0x1 << 2
        stair.physicsBody?.contactTestBitMask = 0x1 << 1
        stair.physicsBody?.collisionBitMask = 0x1 << 1
        
        self.addChild(stair)
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
        
        spike.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 30))
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
        self.view?.presentScene(endScene,transition: trans)
        
    }
    
}
