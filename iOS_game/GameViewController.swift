//
//  GameViewController.swift
//  DownStairs
//
//  Created by mac01 on 2023/5/31.
//

import GameplayKit
import SpriteKit
import UIKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = view as! SKView? {
            let scene = StartScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
}
