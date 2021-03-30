//
//  GameScene.swift
//  Project14
//
//  Created by Rio Michelini on 07/01/2021.
//

import SpriteKit

class GameScene: SKScene {
	
	var slots = [WhackSlot]()
	var gameScore: SKLabelNode!
	var startGame: SKLabelNode!
	
	var popUpTime = 0.85
	var numRounds = 0
	
	var score = 0 {
		didSet {
			gameScore.text = "Score: \(score)"
		}
	}
    
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
		background.position = CGPoint(x: 512, y: 384)
		background.blendMode = .replace
		background.zPosition = -1
		addChild(background)
		
		gameScore = SKLabelNode(fontNamed: "Avenir Heavy")
		gameScore.text = "Score: 0"
		gameScore.position = CGPoint(x: 8, y: 8)
		gameScore.horizontalAlignmentMode = .left
		gameScore.fontSize = 48
		addChild(gameScore)
		
		startGame = SKLabelNode(fontNamed: "Avenir Heavy")
		startGame.text = "Start"
		startGame.horizontalAlignmentMode = .center
		startGame.position = CGPoint(x: 1024 / 2, y: 700)
		startGame.fontColor = SKColor.init(red: 11/255.0, green: 25/255.0, blue: 122/255.0, alpha: 0.9)
		startGame.fontSize = 48
		addChild(startGame)
		
		for i in 0..<5 {
			createSlot(at: CGPoint(x: 100 + (i * 170), y: 410))
		}
		for i in 0..<4 {
			createSlot(at: CGPoint(x: 180 + (i * 170), y: 320))
		}
		for i in 0..<5 {
			createSlot(at: CGPoint(x: 100 + (i * 170), y: 230))
		}
		for i in 0..<4 {
			createSlot(at: CGPoint(x: 180 + (i * 170), y: 140))
		}
		
    }

	
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		guard let touch = touches.first else { return }
		let location = touch.location(in: self)
		let tappedNodes = nodes(at: location)
		
		if tappedNodes.contains(startGame) {
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
				self?.createEnemy()
			}
			startGame.removeFromParent()
		} else {
			for node in tappedNodes {
				guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
				
				if !whackSlot.isVisible { continue }
				if whackSlot.isHit { continue }
				whackSlot.hit()
				
				if let smokeParticle = SKEmitterNode(fileNamed: "SmokeParticle") {
						smokeParticle.position = whackSlot.position
						addChild(smokeParticle)
					}
				
				
				if node.name == "charFriend" {
					// Friend remove a point
					score -= 5
					
					run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
				} else if node.name == "charEnemy" {
					// Enemy add a point
					
					whackSlot.charNode.xScale = 0.75
					whackSlot.charNode.yScale = 0.75
			
					score += 1
					
					run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
				}
			}
		}
    }
	
	func createSlot(at position: CGPoint) {
		let slot = WhackSlot()
		slot.configure(at: position)
		addChild(slot)
		slots.append(slot)
	}
	
	func createEnemy() {
		numRounds += 1
		
		if numRounds >= 50 {
			for slot in slots {
				slot.hide()
			}
			run(SKAction.playSoundFileNamed("gameOver.wav", waitForCompletion: false))
			let gameOver = SKSpriteNode(imageNamed: "gameOver")
			gameOver.position = CGPoint(x: 512, y: 384)
			gameOver.zPosition = 1
			addChild(gameOver)
			let finalScore = SKLabelNode()
			finalScore.text = "Final Score: \(score)"
			finalScore.position = CGPoint(x: 512, y: 300)
			finalScore.horizontalAlignmentMode = .center
			finalScore.fontSize = 36
			finalScore.fontName = "Avenir Heavy"
			finalScore.zPosition = 0
			addChild(finalScore)
			return
		}
		
		popUpTime *= 0.991
		
		slots.shuffle()
		slots[0].show(hideTime: popUpTime)
		
		if Int.random(in: 0...12) > 4 {
			slots[1].show(hideTime: popUpTime)
		}
		if Int.random(in: 0...12) > 8 {
			slots[2].show(hideTime: popUpTime)
		}
		if Int.random(in: 0...12) > 10 {
			slots[3].show(hideTime: popUpTime)
		}
		if Int.random(in: 0...12) > 11 {
			slots[4].show(hideTime: popUpTime)
		}
		
		let minimumDelay = popUpTime / 2.0
		let maximumDelay = popUpTime * 2.0
		
		let delay = Double.random(in: minimumDelay...maximumDelay)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
			self?.createEnemy()
		}
		
	}

}
