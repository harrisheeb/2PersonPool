//
//  GameScene.swift
//  Pong
//
//  Created by Harrison Heeb on 7/13/17.
//  Copyright © 2017 Harrison Heeb. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var dots = [SKSpriteNode]()
    var numDots = 0
    var ball = SKSpriteNode()
    var ball2 = SKSpriteNode()
    let blockTexture = SKTexture(imageNamed: "bowling.png")
    let block2Texture = SKTexture(imageNamed: "bowling2.png")
    let block3Texture = SKTexture(imageNamed: "bowling3.png")
    let block4Texture = SKTexture(imageNamed: "bowling4.png")
    let holeTexture = SKTexture(imageNamed: "hole")
    var realDifX: CGFloat = 0
    var realDifY: CGFloat = 0
    
    var realTime2: Double = 0

    var realTime: Double = 0
    var holes = [SKSpriteNode]()
    var forceBars = [SKSpriteNode]()
    var forceBars2 = [SKSpriteNode]()
    var topLbl = SKLabelNode()
    var btmLbl = SKLabelNode()
    var count = 0
    var force = 0
    var fastTime = Int(0)
    var boop = CGFloat(0.0)
    var isTouching = false
    var numsAdded = false
    var xDif = CGFloat(0.0)
    var yDif = CGFloat(0.0)
    var touchX: CGFloat = 0
    var touchY: CGFloat = 0
    var score = 0
    var score2 = 0
    
    
    let shockWaveAction: SKAction = {
        let growAndFadeAction = SKAction.group([SKAction.scale(to: 50, duration: 0.5), SKAction.fadeOut(withDuration: 0.5)])
        
        let sequence = SKAction.sequence([growAndFadeAction,
                                          SKAction.removeFromParent()])
        
        return sequence
    }()
    
    
    override func didMove(to view: SKView) {
        
        
        
        
        
       // topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        btmLbl = self.childNode(withName: "btmLabel") as! SKLabelNode
        topLbl = self.childNode(withName: "topLabel") as! SKLabelNode
        
        btmLbl.zRotation = -2*3.14*1/4
        topLbl.zRotation = -2*3.14*1/4
        btmLbl.position = CGPoint(x:self.frame.width/3, y:-self.frame.height/4)
        topLbl.position = CGPoint(x:self.frame.width/3, y:self.frame.height/4)

        
        ball = SKSpriteNode(texture: block2Texture)
        ball.position = CGPoint(x: 0, y: -self.frame.height/4)
        ball.size.width = 20
        ball.size.height = 20
        ball.physicsBody = SKPhysicsBody(texture: block2Texture, size: CGSize(width: 20, height: 20))
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.linearDamping = 0.5
        ball.physicsBody?.restitution = 0.01
        ball.name = "ball"


        self.addChild(ball)

        ball2 = SKSpriteNode(texture: block3Texture)
        ball2.position = CGPoint(x: 0, y: self.frame.height/4)
        ball2.size.width = 20
        ball2.size.height = 20
        ball2.physicsBody = SKPhysicsBody(texture: block3Texture, size: CGSize(width: 20, height: 20))
        ball2.physicsBody?.isDynamic = true
        ball2.physicsBody?.affectedByGravity = false
        ball2.physicsBody?.linearDamping = 0.5
        ball2.physicsBody?.restitution = 0.01
        ball2.name = "ball2"
        
        
        self.addChild(ball2)

        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        border.friction = 0.1
        border.restitution = 1.0
        
        self.physicsBody = border
       
        startGame()
        
    }
    func addDot(_ index: Int){
        if(index % 2 == 0){
            dots.append(SKSpriteNode(texture: blockTexture))
        } else {
            dots.append(SKSpriteNode(texture: block4Texture))
        }
        dots[numDots].position = CGPoint(x: 5*index - 50, y: 0)
        dots[numDots].size.width = 20
        dots[numDots].size.height = 20
        dots[numDots].physicsBody = SKPhysicsBody(circleOfRadius: 10)
        dots[numDots].physicsBody?.isDynamic = true
        dots[numDots].physicsBody?.affectedByGravity = false
        dots[numDots].physicsBody?.linearDamping = 0.5
        dots[numDots].physicsBody?.restitution = 0.01
        if(index % 2 == 0){
            dots[numDots].name = "dot"
        } else {
            dots[numDots].name = "dot2"
        }
        
        dots[numDots].physicsBody!.contactTestBitMask = dots[numDots].physicsBody!.collisionBitMask
        


        self.addChild(dots[numDots])
        physicsWorld.contactDelegate = self
        
        numDots = numDots + 1

        
    }
    
    func startGame() {
        
        
        ball.physicsBody?.restitution = 0.5
        ball2.physicsBody?.restitution = 0.5
        for var i in 0...9 {
            addDot(i)

        }
        
        for var i in 0...5 {
            forceBars.append(SKSpriteNode(color: UIColor.black, size: CGSize(width: 5, height: 5)))
            forceBars2.append(SKSpriteNode(color: UIColor.black, size: CGSize(width: 5, height: 5)))
            holes.append(SKSpriteNode(texture: holeTexture, size: CGSize(width: 40, height: 40)))
            self.addChild(holes[i])
            holes[i].physicsBody = SKPhysicsBody(circleOfRadius: 20)
            holes[i].physicsBody?.isDynamic = false
            holes[i].physicsBody?.affectedByGravity = false
            holes[i].name = "hole"
            holes[i].physicsBody!.contactTestBitMask = holes[i].physicsBody!.collisionBitMask
        }
        
        
        holes[0].position = CGPoint(x: self.frame.width/2 - 5, y: self.frame.height/2 - 20)
        holes[1].position = CGPoint(x: self.frame.width/2 - 5, y: 0)
        holes[2].position = CGPoint(x: self.frame.width/2 - 5, y: -self.frame.height/2 + 20)
        holes[3].position = CGPoint(x: -self.frame.width/2 + 5, y: self.frame.height/2 - 20)
        holes[4].position = CGPoint(x: -self.frame.width/2 + 5, y: 0)
        holes[5].position = CGPoint(x: -self.frame.width/2 + 5, y: -self.frame.height/2 + 20)
        

        
        for forceBar in forceBars {
            
            forceBar.position = CGPoint(x: 700, y: 700)
            
            self.addChild(forceBar)
        }
        for forceBar in forceBars2 {
            
            forceBar.position = CGPoint(x: 700, y: 700)
            
            self.addChild(forceBar)
        }
        

    } 
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.node?.name == "hole" && contact.bodyB.node?.name == "dot"){
            contact.bodyB.node!.removeFromParent()
            score = score + 1
        }
        
        if (contact.bodyA.node?.name == "dot" && contact.bodyB.node?.name == "hole"){
            contact.bodyA.node!.removeFromParent()
            score = score + 1
            
        }
        if (contact.bodyA.node?.name == "hole" && contact.bodyB.node?.name == "dot2"){
            contact.bodyB.node!.removeFromParent()
            score2 = score2 + 1
        }
        
        if (contact.bodyA.node?.name == "dot2" && contact.bodyB.node?.name == "hole"){
            contact.bodyA.node!.removeFromParent()
            score2 = score2 + 1
            
        }
        
        if (contact.bodyA.node?.name == "dot" && (contact.bodyB.node?.name == "ball" || contact.bodyB.node?.name == "ball2")){
            let shockwave = SKShapeNode(circleOfRadius: 1)
        
            shockwave.position = contact.contactPoint
            scene!.addChild(shockwave)
        
            shockwave.run(shockWaveAction)
        }
        if (contact.bodyB.node?.name == "dot" && (contact.bodyA.node?.name == "ball" || contact.bodyB.node?.name == "ball2")){
            let shockwave = SKShapeNode(circleOfRadius: 1)
            
            shockwave.position = contact.contactPoint
            scene!.addChild(shockwave)
            
            shockwave.run(shockWaveAction)
        }
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouching = true
        for touch in touches {
            let location = touch.location(in: self)
            touchX = location.x
            touchY = location.y
            if(location.y < 0){
                ball.physicsBody?.applyImpulse(CGVector(dx: cos(Double(realTime)*3)*5, dy: sin(Double(realTime)*3)*5))
            } else {
                ball2.physicsBody?.applyImpulse(CGVector(dx: cos(Double(realTime2)*3)*5, dy: sin(Double(realTime2)*3)*5))
            }

        }
        
    }
    
    
   
    
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            touchX = location.x
            touchY = location.y

           
            
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            xDif = ((ball.position.x - location.x)/5)/10
            yDif = ((ball.position.y - location.y)/5)/10
            //ball.physicsBody?.applyImpulse(CGVector(dx: xDif, dy: yDif))

            
           /* if(location.x > 0){
                ball.physicsBody?.applyImpulse(CGVector(dx: -force, dy: force))
            } else {
                ball.physicsBody?.applyImpulse(CGVector(dx: force, dy: force))
                
            } */
            isTouching = false
        }
        for var i in 0...5 {
            forceBars[i].position.x = 700
            forceBars[i].position.y = 700
            forceBars[i].color = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        }
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
       realTime = Double(currentTime)
        realTime2 = Double(currentTime + 15)
        realDifX = (ball.position.x - touchX)
        realDifY = (ball.position.y - touchY)
        
            for var i in 0...5 {
                forceBars[i].position.x = (ball.position.x + CGFloat(cos(Double(currentTime)*3)*5) * CGFloat(i*3))
                forceBars[i].position.y = (ball.position.y + CGFloat(sin(Double(currentTime)*3)*5) * CGFloat(i*3))
                
                forceBars2[i].position.x = (ball2.position.x + CGFloat(cos(Double(realTime2)*3)*5) * CGFloat(i*3))
                forceBars2[i].position.y = (ball2.position.y + CGFloat(sin(Double(realTime2)*3)*5) * CGFloat(i*3))
            }
            forceBars[force % 5].color = UIColor.white
            forceBars2[force % 5].color = UIColor.white
            if(force % 5 != 0){
                forceBars[force % 5 - 1].color = UIColor.black
                forceBars2[force % 5 - 1].color = UIColor.black

            } else {
                forceBars[4].color = UIColor.black
                forceBars2[4].color = UIColor.black

            }

        
        
        fastTime = Int(currentTime * 100)
        boop = CGFloat(fastTime % 200)
        
        
        
        
        if (fastTime % 10 < 5 && numsAdded == false){
            force = force + 1
            //addDot()
                
            numsAdded = true
        }
        
        if(fastTime % 10 > 5){
            numsAdded = false
        }
        
        
        topLbl.text = "\(score2)"
        btmLbl.text = "\(score)"
        
        
        var shmoop = CGFloat(0.0)
        if (boop > 100) {
            shmoop = CGFloat(200 - boop)/400
        } else {
            
            shmoop = CGFloat(boop)/400
        }
        
        backgroundColor = UIColor(red: 0, green: 0, blue: 1-shmoop, alpha: 1)
        
        
        }
        
        
    
    
}
