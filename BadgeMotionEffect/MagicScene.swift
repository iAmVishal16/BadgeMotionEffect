//
//  MagicScene.swift
//  MotionButtonEffect
//
//  Created by Vishal Paliwal on 06/07/23.
//

import Foundation
import SpriteKit

class MagicScene: SKScene {

    let snowEmitterNode = SKEmitterNode(fileNamed: "MagicParticle.sks")

    override func didMove(to view: SKView) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particleSize = CGSize(width: 30, height: 30)
        snowEmitterNode.particleLifetime = 5
        snowEmitterNode.particleLifetimeRange = 10
        addChild(snowEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let snowEmitterNode = snowEmitterNode else { return }
        snowEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        snowEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: size.height)
    }
}
