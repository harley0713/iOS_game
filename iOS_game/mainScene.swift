//
//  MainScene.swift
//  DownStairs
//
//  Created by mac01 on 2023/6/1.
//

import UIKit
import SpriteKit

class MainScene: SKScene {
    var mainbgd: SKSpriteNode!
     
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func createScene(){
        mainbgd = SKSpriteNode(imageNamed: "mainbgd")
        mainbgd.size.width = self.size.width
        mainbgd.size.height = self.size.height
        mainbgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        mainbgd.zPosition = -1
        self.addChild(mainbgd)
        
        let Lwall = SKSpriteNode(imageNamed: "wall")
        Lwall.size.width = 20;
        Lwall.size.height = self.size.height
        Lwall.physicsBody?.isDynamic = false
        Lwall.position = CGPoint(x: 10 , y: self.size.height/2)
        Lwall.zPosition = 1
        self.addChild(Lwall)
        
        let Rwall = SKSpriteNode(imageNamed: "wall")
        Rwall.size.width = 20;
        Rwall.size.height = self.size.height
        Rwall.physicsBody?.isDynamic = false
        Rwall.position = CGPoint(x: self.size.width - 10, y: self.size.height/2)
        Rwall.zPosition = 1
        self.addChild(Rwall)
        
        let ceiling = SKSpriteNode(imageNamed: "ceiling")
        ceiling.size.width = self.size.width
        ceiling.size.height = 20;
        ceiling.physicsBody?.isDynamic = false
        ceiling.position = CGPoint(x: self.size.width/2, y: self.size.height - 10)
        ceiling.zPosition = 1
        self.addChild(ceiling)
    }
    
    
}
