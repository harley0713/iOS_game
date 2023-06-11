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
        var highscore: Int
    }
    var point = 0
    var highScore:Int = 0
    var label1: SKLabelNode!
    var label2: SKLabelNode!
    var tmp1: Int = 0
    
    
    override func didMove(to view: SKView) {
        
        
        createScene()
        let Data = Score(highscore: self.highScore)
        print(Data.highscore)
        self.setBestScore(data: Data)
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
        
        let score = SKLabelNode()
        score.text = "\(point)"
        score.fontSize = 50
        score.fontColor = .black
        score.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 80)
        score.name = "score"
        score.zPosition = 1
        self.addChild(score)

        label1 = SKLabelNode(fontNamed: "Avenir-Oblique")
        label1.fontSize = 50
        label1.fontColor = .black
        label1.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 130)
        label1.name = "label1"
        label1.zPosition = 1
        
        label2 = SKLabelNode(fontNamed: "Avenir-Oblique")
        label2.text = "Highest Score: \(highScore)"
        label2.fontSize = 20
        label2.fontColor = .black
        label2.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 40)
        label2.name = "label2"
        label2.zPosition = 1
        
        if point > highScore{
            highScore = point
            label1.text = "New Record!!!"
            label2.text = "Highest Score: \(point)"
        }else{
            label1.text = "Nice Try"
        }
        
        self.addChild(label1)
        self.addChild(label2)
    }
    
    func setBestScore(data: Score){
        if let path = Bundle.main.url(forResource: "score", withExtension: "plist"){
            do{
                let data = try PropertyListEncoder().encode(data)
                try data.write(to: path)
                print("written")
                if let tmp = try? PropertyListDecoder().decode(Score.self, from: data){
                    self.tmp1 = tmp.highscore
                    print("\(self.tmp1)")
                }
            }catch{
                print(error)
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchnode = atPoint(location)
            if touchnode.name == "reset"{
                let mainScene = MainScene(size: self.size)
                mainScene.highScore = self.highScore
                let doors = SKTransition.doorsOpenVertical(withDuration: 0.5)
                self.view?.presentScene(mainScene, transition: doors)
            }
        }
    }
    
}
