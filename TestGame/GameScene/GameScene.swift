//
//  MainGameScene.swift
//  TestGame
//
//  Created by Raynelle Francisca on 02/04/2021.
//

import UIKit
import SpriteKit

struct ColliderType {
    static let Bullet: UInt32 = 1
    static let Ufo: UInt32 = 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var score = 0
    var enemyCount = 10
    private var scorelabel : SKLabelNode?
    var planeAnimation = [SKTexture]()

    override func didMove(to view: SKView) {

        self.physicsWorld.contactDelegate = self
        //2 - Get our animation set
        //Get the images from the .atlas folder
        let shooterPlaneAtlas = SKTextureAtlas(named: "shooterPlane")
        for index in 1...shooterPlaneAtlas.textureNames.count {
            let imgName = String(format: "shooterPlane%1d", index)
            planeAnimation.append(shooterPlaneAtlas.textureNamed(imgName))
        }

        let dropUfos = SKAction.run({
            self.createUfoNode()
        })
        let dropdropUfosSeq = SKAction.sequence([dropUfos, SKAction.wait(forDuration: 1.0)])
        self.run(SKAction.repeat(dropdropUfosSeq, count: 10))
    }

    // Animate the plane
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 3 - run the fighterPlane shooter animation
        if let planeNode = self.childNode(withName: "//shooterPlaneNode") {
            let animation = SKAction.animate(with: planeAnimation, timePerFrame: 0.1)

            let shootBullet = SKAction.run({
                let bulletNode = self.createBulletnode()
                self.addChild(bulletNode)
                bulletNode.physicsBody?.applyImpulse(CGVector(dx: 80, dy: 0))
            })

            let seq = SKAction.sequence([animation, shootBullet])
            planeNode.run(seq)

        }
    }

    //4 - Create the bullet node
    func createBulletnode() -> SKSpriteNode {
        //get main shooter characters width & positions
        let planeNode = self.childNode(withName: "shooterPlaneNode")
        let planeNodePosition = planeNode?.position
        let planeNodeWidth = planeNode?.frame.size.width

        //set the default position of the bullet
        let bullet = SKSpriteNode(imageNamed: "bullet.png")
        bullet.position = CGPoint(x: planeNodePosition!.x + planeNodeWidth!/2, y: planeNodePosition!.y)
        bullet.name = "bulletNode"
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.frame.size)
        bullet.physicsBody?.categoryBitMask = ColliderType.Bullet
        bullet.physicsBody?.collisionBitMask = ColliderType.Ufo
        bullet.physicsBody?.contactTestBitMask = ColliderType.Ufo
        return bullet

    }

    //6 - Create the Ufos
    func createUfoNode() {
        let ufo = SKSpriteNode(imageNamed: "ufo.png")
        ufo.position = CGPoint(x: randomNumber(maximum: self.size.width/2), y: self.size.height)
        ufo.name = "ufoNode"
        ufo.physicsBody = SKPhysicsBody(rectangleOf: ufo.frame.size)
        ufo.physicsBody?.categoryBitMask = ColliderType.Ufo
        self.addChild(ufo)
    }

    //returns a random value from 0 to max value
    func randomNumber(maximum: CGFloat) -> CGFloat {
        let maxInt = UInt32(maximum)
        let result = arc4random_uniform(maxInt)
        return CGFloat(result)

    }

    // 8 - Detect Collision and update the score
    func didBegin(_ contact: SKPhysicsContact) {
        let nodeNames = [contact.bodyA.node?.name, contact.bodyB.node?.name]
        if nodeNames.contains("bulletNode") && nodeNames.contains("ufoNode") {
            print("Contact detected")
            score += 1
            self.scorelabel = self.childNode(withName: "//score") as? SKLabelNode
            self.scorelabel?.text = "Score \(score)/\(enemyCount)"

            let removeFromScene = SKAction.run({
                contact.bodyA.node?.removeFromParent()
                contact.bodyB.node?.removeFromParent()
            })

            let seq = SKAction.sequence([SKAction.wait(forDuration: 2.0), removeFromScene])
            self.run(seq)

        }
    }
}
