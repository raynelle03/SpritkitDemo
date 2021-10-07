//
//  GameScene.swift
//  TestGame
//
//  Created by Raynelle Francisca on 31/03/2021.
//

import SpriteKit
import GameplayKit

class IntroScene: SKScene {
    
    private var label : SKLabelNode?
    
    override func didMove(to view: SKView) {
        self.label = self.childNode(withName: "//tapToPlayLabel") as? SKLabelNode
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            let fadeOut = SKAction.fadeOut(withDuration: 1.5)

            label.run(fadeOut, completion: {
                if let gameScene = GameScene(fileNamed: "GameScene") {
                    self.view?.presentScene(gameScene, transition: SKTransition.doorway(withDuration: 1.5))
                }

            })
        }

    }

}
