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
     
    override func didMove(to view: SKView) {
        createScene()
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        print(self.size.width)
    }
    
    func createScene(){
        mainbgd = SKSpriteNode(imageNamed: "mainbgd")
        mainbgd.size.width = self.size.width
        mainbgd.size.height = self.size.height
        mainbgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mainbgd.zPosition = -1
        self.addChild(mainbgd)
        
        Lwall = SKSpriteNode(imageNamed: "wall")
        Lwall.size.width = 20;
        Lwall.size.height = self.size.height
        Lwall.physicsBody?.isDynamic = false
        Lwall.position = CGPoint(x: 10 , y: self.size.height/2)
        Lwall.zPosition = 1
        self.addChild(Lwall)
        
        Rwall = SKSpriteNode(imageNamed: "wall")
        Rwall.size.width = 20;
        Rwall.size.height = self.size.height
        Rwall.physicsBody?.isDynamic = false
        Rwall.position = CGPoint(x: self.size.width - 10, y: self.size.height/2)
        Rwall.zPosition = 1
        self.addChild(Rwall)
        
        ceiling = SKSpriteNode(imageNamed: "ceiling")
        ceiling.size.width = self.size.width
        ceiling.size.height = 20;
        ceiling.physicsBody?.isDynamic = false
        ceiling.position = CGPoint(x: self.size.width/2, y: self.size.height - 10)
        ceiling.zPosition = 1
        self.addChild(ceiling)
        
        startPlatform()
        
        stairGenerator = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(newStep), userInfo: nil, repeats: true)
        //spikeGenerator = Timer.scheduledTimer(timeInterval: 6.7, target: self, selector: #selector(newSpike), userInfo: nil, repeats: true)
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
        startP.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 20))
        startP.physicsBody?.usesPreciseCollisionDetection = true
        startP.run(remove)
        self.addChild(startP)
    }
    
    func createPlayer()->SKSpriteNode{
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: self.size.width/2, y: 120)
        player.name = "player"
        
        return player
    }
    
    func newStair(){
        stair = SKSpriteNode(imageNamed: "normal")
        stair.size = CGSize(width: 100, height: 20)
        let remove = SKAction.sequence([SKAction.moveTo(y: self.size.height + 150, duration: 7),SKAction.removeFromParent()])
        let w = self.size.width - 140
        var x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        while abs(previousX-x) < 40{
            x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        }
        stair.position = CGPoint(x: x, y: 0)
        previousX = x
        stair.name = "stairs"
        stair.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 20))
        stair.physicsBody?.usesPreciseCollisionDetection = true
        stair.run(remove)
        self.addChild(stair)
        
        
    }
    
    func newSpike(){
        spike = SKSpriteNode(imageNamed: "spike")
        spike.size = CGSize(width: 60, height: 30)
        let remove = SKAction.sequence([SKAction.moveTo(y: self.size.height + 150, duration: 7),SKAction.removeFromParent()])
        let w = self.size.width - 140
        var x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        while abs(previousX-x) < 40{
            x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w) + 70
        }
        spike.position = CGPoint(x: x, y: 0)
        previousX = x
        spike.name = "spikes"
        spike.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 30))
        spike.physicsBody?.usesPreciseCollisionDetection = true
        self.addChild(spike)
        spike.run(remove)
    }
    
}
