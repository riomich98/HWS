//
//  GameScene.swift
//  ChallengeProject6
//
//  Created by Rio Michelini on 11/01/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var scoreLabel: SKLabelNode!
	
	var isGameOver: Bool = false
	var gameTimer: Timer?
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: size.width/2, y: size.height/2)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		scoreLabel = SKLabelNode(fontNamed: "Avenir Heavy")
		scoreLabel.text = "Score: 0"
		scoreLabel.position = CGPoint(x: 200, y: 38)
		scoreLabel.horizontalAlignmentMode = .left
		addChild(scoreLabel)
		
		score = 0
		
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
		
    }

    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		if !isGameOver {
			score += 1
		}
    }
}
