//
//  GameScene.swift
//  Project11
//
//  Created by Rio Michelini on 21/12/2020.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var scoreLabel: SKLabelNode!
	var editLabel: SKLabelNode!
	var remainingLabel: SKLabelNode!
	var optionsBox: SKSpriteNode!
	
	var balls = ["Red","Blue","Yellow","Purple","Green","Cyan"]
	
	var editingMode: Bool = false {
		didSet {
			if editingMode {
				editLabel.text = "Done"
			} else {
				editLabel.text = "Edit"
			}
		}
	}
	
	var score = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	var maxBalls = 5 {
		didSet {
			remainingLabel.text = "Balls Remaining: \(maxBalls)"
		}
	}
    
    override func didMove(to view: SKView) {
		let background = SKSpriteNode(imageNamed: "background")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -2
		addChild(background)
		
		optionsBox = SKSpriteNode(color: UIColor(red: 0, green: 0, blue: 0, alpha: 1), size: CGSize(width: 2048, height: 240))
		optionsBox.blendMode = .alpha
		optionsBox.position = CGPoint(x: 1024, y: 768)
		optionsBox.zPosition = -1
		addChild(optionsBox)
		
		scoreLabel = SKLabelNode(fontNamed: "Avenir")
		scoreLabel.text = "Score: 0"
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.position = CGPoint(x: 980, y: 700)
		addChild(scoreLabel)
		
		editLabel = SKLabelNode(fontNamed: "Avenir")
		editLabel.text = "Edit"
		editLabel.horizontalAlignmentMode = .left
		editLabel.position = CGPoint(x: 80, y: 700)
		addChild(editLabel)
		
		remainingLabel = SKLabelNode(fontNamed: "Avenir")
		remainingLabel.text = "Balls Remaining: 5"
		remainingLabel.horizontalAlignmentMode = .center
		remainingLabel.position = CGPoint(x: 1024 / 2, y: 700)
		addChild(remainingLabel)
		
		physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
		physicsWorld.contactDelegate = self
		
		makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
		makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
		makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

		makeBouncer(at: CGPoint(x: 0, y: 0))
		makeBouncer(at: CGPoint(x: 256, y: 0))
		makeBouncer(at: CGPoint(x: 512, y: 0))
		makeBouncer(at: CGPoint(x: 768, y: 0))
		makeBouncer(at: CGPoint(x: 1024, y: 0))
		balls.shuffle()
    }
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		
		let objects = nodes(at: location)
		
		if objects.contains(editLabel) {
			editingMode.toggle()
		} else {
			if editingMode {
				let size = CGSize(width: Int.random(in: 16...128), height: 16)
				let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
				box.zRotation = CGFloat.random(in: 0...3)
				box.position = location
				box.name = "Box"
				box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
				box.physicsBody?.isDynamic = false
				addChild(box)
			} else {
				if maxBalls > 0 {
					let ball = SKSpriteNode(imageNamed: "\("ball" + balls[Int.random(in: 0...5)])")
					ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
					ball.physicsBody?.restitution = 0.6
					ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
					ball.position = CGPoint(x: location.x, y: 768)
					ball.name = "Ball"
					addChild(ball)
					maxBalls -= 1
				} else {
					
				}
			}
		}
	}
	
	func makeBouncer(at position: CGPoint) {
		let bouncer = SKSpriteNode(imageNamed: "bouncer")
		bouncer.position = position
		bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2)
		bouncer.physicsBody?.isDynamic = false
		bouncer.zPosition = 2
		addChild(bouncer)
	}
	
	func makeSlot(at position: CGPoint, isGood: Bool) {
		var slotBase: SKSpriteNode
		var slotGlow: SKSpriteNode
		
		if isGood {
			slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
			slotBase.name = "Good"
		} else {
			slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
			slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
			slotBase.name = "Bad"
		}
		
		slotBase.position = position
		slotBase.zPosition = 0
		slotGlow.position = position
		slotGlow.zPosition = 1
		
		slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
		slotBase.physicsBody?.isDynamic = false
		
		addChild(slotGlow)
		addChild(slotBase)
		
		let spin = SKAction.rotate(byAngle: .pi, duration: 10)
		let spinForever = SKAction.repeatForever(spin)
		slotGlow.run(spinForever)
	}
	
	func collision(between ball: SKNode, object: SKNode) {
		if object.name == "Good" {
			destroy(object: ball)
			score += 1
			maxBalls += 1
		} else if object.name == "Bad" {
			destroy(object: ball)
			score -= 1
		}
	}
	
	func obstacleBox(between obstacle: SKNode, ball: SKNode) {
		if obstacle.name == "Box" {
			destroy(object: obstacle)
		}
	}

	func destroy(object: SKNode) {
		if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
			fireParticles.position = object.position
			addChild(fireParticles)
		}
		object.removeFromParent()
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		guard let nodeA = contact.bodyA.node else { return }
		guard let nodeB = contact.bodyB.node else { return }
		if nodeA.name == "Ball" {
			collision(between: nodeA, object: nodeB)
		} else if nodeB.name == "Ball" {
			collision(between: nodeB, object: nodeA)
		}
		if nodeA.name == "Box" && nodeB.name == "Ball" {
			destroy(object: nodeA)
		}
	}

}
