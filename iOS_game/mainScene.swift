//
//  MainScene.swift
//  DownStairs
//
//  Created by mac01 on 2023/6/1.
//
//  self.size.width = 393.0

import UIKit
import SpriteKit

class MainScene: SKScene {
    var mainbgd: SKSpriteNode!
    var Lwall: SKSpriteNode!
    var Rwall: SKSpriteNode!
    var ceiling: SKSpriteNode!
    var stair: SKSpriteNode!
    var spike: SKSpriteNode!
     
    override func didMove(to view: SKView) {
        createScene()
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        //print(self.size.width)
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
    }
    
    @objc func newStair(){
        stair = SKSpriteNode(imageNamed: "normal")
        //stair.size = CGSize(width: 40, height: 10)
        let remove = SKAction.sequence([SKAction.wait(forDuration: 10),SKAction.removeFromParent()])
        let w = self.size.width
        let h = 60
        let x = CGFloat(arc4random()).truncatingRemainder(dividingBy: w)
        stair.position = CGPoint(x: x, y: h)
        stair.name = "stair"
        self.addChild(stair)
        stair.physicsBody?.usesPreciseCollisionDetection = true
        stair.physicsBody?.affectedByGravity = false
        
    }
    
    @objc func newSpike(){
        spike = SKSpriteNode(imageNamed: "nail")
        
        let remove = SKAction.sequence([SKAction.wait(forDuration: 10),SKAction.removeFromParent()])
        let w = self.size.width
    }
    
}
