//
//  StartScene.swift
//  DownStairs
//
//  Created by mac01 on 2023/6/1.
//

import UIKit
import SpriteKit

class StartScene: SKScene {
    
    
    /*
     struct Score: Codable{
         var highScore: Int
     }
     */
    var userdefault: UserDefaults = UserDefaults.standard
    var highScore = 0
    var path: String = ""
    override func didMove(to view: SKView) {
        let check = userdefault.object(forKey: "highscore") as! Int?
        if check == nil{
            userdefault.set(0, forKey: "highscore")
        }
        highScore = userdefault.integer(forKey: "highscore")
        
        //self.getBestScore()
        //print("\(highScore)")
        //print("\(highScore)")
        /*
         path = NSHomeDirectory() + "/Documents/score.plist"
         if let plist = NSMutableDictionary(contentsOfFile: path){
             highScore = plist["highScore"] as! Int
             print("\(highScore)")
         }
         */
        
        
        createScene()
        //print(self.size.width)
    }
    
    func createScene(){
        let bgd = SKSpriteNode(imageNamed: "stair")
        bgd.size.width = self.size.width
        bgd.size.height = self.size.height
        bgd.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bgd.zPosition = -1
        
        let Title = SKLabelNode(text: "DOWNSTAIR")
        Title.name = "gameTitle"
        Title.numberOfLines = 0
        Title.position = CGPoint(x: self.frame.midX - 80, y: self.frame.midY + 90)
        Title.fontName = "Avenir-Oblique"
        Title.fontColor = .black
        Title.fontSize = 35
        
        let StartB = SKSpriteNode(imageNamed: "startButton")
        StartB.name = "start"
        StartB.size = CGSize(width: 180, height: 40)
        StartB.position = CGPoint(x: self.frame.midX + 80, y: self.frame.midY - 80)
        StartB.zPosition = 1
        
        let best = SKLabelNode()
        best.text = "Highest Score:\n\(highScore)"
        best.numberOfLines = 0
        best.position = CGPoint(x: self.frame.midX + 80, y: self.frame.midY - 200)
        best.fontName = "Avenir-Oblique"
        best.fontColor = .black
        best.fontSize = 20
        
        
        self.addChild(bgd)
        self.addChild(Title)
        self.addChild(StartB)
        self.addChild(best)
    }
    
    
    
     
     /*
      func getBestScore(){
          if let path = Bundle.main.path(forResource: "score", ofType: "plist"),
             let file = FileManager.default.contents(atPath: path),
             let hs = try? PropertyListDecoder().decode(Score.self, from: file){
              self.highScore = hs.highScore
          }
      }
      */
    
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
                    mainScene.highScore = self.highScore
                    let trans = SKTransition.doorway(withDuration: 1)
                    self.view?.presentScene(mainScene, transition: trans)
                })
            }
        }
    }
    
}
