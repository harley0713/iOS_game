//
//  endScene.swift
//  iOS_game
//
//  Created by mac01 on 2023/6/11.
//

import UIKit
import SpriteKit

class endScene: SKScene {
    
    struct Score: Codable{
        var highScore: Int
    }
    var point = 0
    var highScore:Int = 0
    var label1: SKLabelNode!
    var label2: SKLabelNode!
    
    
    override func didMove(to view: SKView) {
        self.getBestScore()
        createScene()
        //print(self.size.width)
    }
    
    func createScene(){
        let bgd = SKSpriteNode(imageNamed: "endbgd")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        self.addChild(bgd)
        
        
        let Reset = SKSpriteNode(imageNamed: "tryAgain")
        Reset.name = "reset"
        Reset.size = CGSize(width: 200, height: 200)
        Reset.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        Reset.zPosition = 1
        self.addChild(Reset)
        
        
    }
    
    func getBestScore(){
        if let path = Bundle.main.path(forResource: "score", ofType: "plist"),
           let file = FileManager.default.contents(atPath: path),
           let hs = try? PropertyListDecoder().decode(Score.self, from: file){
            self.highScore = hs.highScore
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchnode = atPoint(location)
            if touchnode.name == "reset"{
                let mainScene = MainScene(size: self.size)
                let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
                self.view?.presentScene(mainScene, transition: doors)
            }
        }
    }
    
}
