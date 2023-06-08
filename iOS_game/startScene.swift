//
//  StartScene.swift
//  DownStairs
//
//  Created by mac01 on 2023/6/1.
//

import UIKit
import SpriteKit

class StartScene: SKScene {
    
    
    override func didMove(to view: SKView) {
        createScene()
    }
    
    func createScene(){
        let bgd = SKSpriteNode(imageNamed: "stair")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        
        let Title = SKLabelNode(text: "STAIRCASE\nTO\nHELL")
        Title.name = "gameTitle"
        Title.numberOfLines = 0
        Title.position = CGPoint(x: self.frame.midX - 80, y: self.frame.midY)
        Title.fontName = "Avenir-Oblique"
        Title.fontColor = .black
        Title.fontSize = 35
        
        let StartB = SKSpriteNode(imageNamed: "startButton")
        StartB.name = "start"
        StartB.size = CGSize(width: 180, height: 40)
        StartB.position = CGPoint(x: self.frame.midX + 80, y: self.frame.midY - 80)
        StartB.zPosition = 1
        
        
        
        self.addChild(bgd)
        self.addChild(Title)
        self.addChild(StartB)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let labelNode = self.childNode(withName: "gameTitle")
        //let moveup = SKAction.moveBy(x: 0, y: 200, duration: 1)
        let pause = SKAction.wait(forDuration: 0.5)
        let movesequence = SKAction.sequence([pause])
        for touch in touches {
            let location = touch.location(in: self)
            let touchnode = atPoint(location)
            if touchnode.name == "start"{
                self.childNode(withName: "start")?.removeFromParent()
                labelNode?.run(movesequence,completion: {
                    let mainScene = MainScene(size: self.size)
                    let trans = SKTransition.doorway(withDuration: 1)
                    self.view?.presentScene(mainScene, transition: trans)
                })
            }
        }
    }
    
}