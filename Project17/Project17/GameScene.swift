//
//  GameScene.swift
//  Project17
//
//  Created by Rio Michelini on 09/01/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	var starfield: SKEmitterNode!
	var player: SKSpriteNode!
	var scoreLabel: SKLabelNode!
	
	var possibleEnemies = ["ball","hammer","tv"]
	var gameTimer: Timer?
	var isGameOver = false
	var isPlayerTouched = false
	var enemiesMade: Int = 0
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
    
    override func didMove(to view: SKView) {
		backgroundColor = .black
		starfield = SKEmitterNode(fileNamed: "starfield")!
		starfield.position = CGPoint(x: 1024, y: 384)
		starfield.advanceSimulationTime(10)
		addChild(starfield)
		starfield.zPosition = -1
		
		player = SKSpriteNode(imageNamed: "player")
		player.position = CGPoint(x: 100, y: 384)
		player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
		player.physicsBody?.contactTestBitMask = 1
		player.name = "player"
		addChild(player)
		
		scoreLabel = SKLabelNode(fontNamed: "Avenir Heavy")
		scoreLabel.position = CGPoint(x: 16, y: 16)
		scoreLabel.horizontalAlignmentMode = .left
		addChild(scoreLabel)
		
		score = 0
		
		physicsWorld.gravity = .zero
		physicsWorld.contactDelegate = self
		
		let gameTimeInterval = 0.5
		
		gameTimer = Timer.scheduledTimer(timeInterval: gameTimeInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
		
    }
	
	@objc func createEnemy() {
		if !isGameOver {
			guard let enemy = possibleEnemies.randomElement() else { return }
			
			let sprite = SKSpriteNode(imageNamed: enemy)
			sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
			sprite.name = "enemy"
			enemiesMade += 1
			addChild(sprite)
			
			sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
			sprite.physicsBody?.categoryBitMask = 1
			sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
			sprite.physicsBody?.angularVelocity = 5
			sprite.physicsBody?.linearDamping = 0
			sprite.physicsBody?.angularDamping = 0
		}
	}
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
		for node in children {
			if node.position.x < -300 {
				node.removeFromParent()
			}
		}
		
		if !isGameOver {
			score += 1
		}
    }
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		var location = touch.location(in: self)

		if isPlayerTouched {
			if location.y < 100 {
				location.y = 100
			} else if location.y > 668 {
				location.y = 668
			}
			
			player.position = location
		}
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		for node in nodes(at: location) {
			if node.name == "player" {
				isPlayerTouched = false
			}
		}
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		for node in nodes(at: location) {
			if node.name == "player" {
				isPlayerTouched = true
			}
		}
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		let explosion = SKEmitterNode(fileNamed: "explosion")!
		explosion.position = player.position
		addChild(explosion)
		
		player.removeFromParent()
		isGameOver = true
	}
}
