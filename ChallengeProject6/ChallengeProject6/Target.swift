//
//  Target.swift
//  ChallengeProject6
//
//  Created by Rio Michelini on 11/01/2021.
//
import SpriteKit

class Target: SKNode {
	var target: SKSpriteNode!
	var targetStick: SKSpriteNode!
	
	func setup() {
		
		let targetType = Int.random(in: 1...2)
		target = SKSpriteNode(imageNamed: "target\(targetType)")
		targetStick = SKSpriteNode(imageNamed: "stick")
	}
	
	func hit() {
		removeAllActions()
		target.name = nil
		
		let animationTime = 0.2
		target.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: animationTime))
		targetStick.run(SKAction.colorize(with: .black, colorBlendFactor: 1, duration: animationTime))
		run(SKAction.fadeOut(withDuration: animationTime))
		run(SKAction.moveBy(x: 0, y: -30, duration: animationTime))
		run(SKAction.scaleX(by: 0.8, y: 0.7, duration: animationTime))
	}
}
