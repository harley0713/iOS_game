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
    }
}
