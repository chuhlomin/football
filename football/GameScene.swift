//
//  GameScene.swift
//  football
//
//  Created by Konstantin Chukhlomin on 13/02/15.
//  Copyright (c) 2015 Konstantin Chukhlomin. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    var game: Game?
    var shiftX: Int = 0;
    var shiftY: Int = 0;
    var deltaX: Int = 0;
    var deltaY: Int = 0;
    
    override func didMoveToView(view: SKView) {
//         Setup your scene here 
//        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
//        myLabel.text = "Hello, World!";
//        myLabel.fontSize = 65;
//        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame));
//        self.addChild(myLabel)
        
        let boardWidth = 11
        let boardHeight = 13
        let board = Board(width: boardWidth, height: boardHeight, goalMargin: 3)
        self.game = Game(board: board)
        
        calcDeltaAndShift(board)
        drawDotsZero(board)
        drawWall()
        
        placeDot(game!.lastDot)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let locationIndex = self.getNearestDotIndex(location)
            
            if let currentDot = game?.board.getDot(locationIndex) {
                if currentDot == game?.board.EMPTY {
                    game?.makeMove(locationIndex)
                    placeDot(locationIndex)
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    func calcDeltaAndShift(board: Board) -> Void {
        deltaX = Int(self.size.width / CGFloat(board.width))
        deltaY = Int(self.size.height / CGFloat(board.height))
        
        if (deltaY > deltaX) {
            deltaY = deltaX
            shiftY = Int((Int(self.size.height) - (board.height * deltaY)) / 2)
        } else if (deltaX > deltaY) {
            deltaX = deltaY
            shiftX = Int((Int(self.size.width) - (board.width * deltaX)) / 2)
        }
    }
    
    func drawDotsZero(board: Board) -> Void {
        for indexX in 0...board.width {
            for indexY in 0...board.height {
                if (board.board[indexX][indexY] != board.EMPTY) {
                    continue
                }
                
                let dotZero = SKSpriteNode(imageNamed:"DotZero")
                dotZero.xScale = 0.1
                dotZero.yScale = 0.1
                dotZero.position = CGPoint(
                    x: CGFloat(indexX * deltaX + shiftX),
                    y: CGFloat(indexY * deltaY + shiftY)
                )
                self.addChild(dotZero)
            }
        }
    }
    
    func drawWall() -> Void {
        var ref = CGPathCreateMutable()
        CGPathMoveToPoint(ref, nil, CGFloat(shiftX + deltaX), CGFloat(shiftY + deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 4*deltaX), CGFloat(shiftY + deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 4*deltaX), CGFloat(shiftY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 6*deltaX), CGFloat(shiftY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 6*deltaX), CGFloat(shiftY + deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 9*deltaX), CGFloat(shiftY + deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 9*deltaX), CGFloat(shiftY + 11*deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 6*deltaX), CGFloat(shiftY + 11*deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 6*deltaX), CGFloat(shiftY + 12*deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 4*deltaX), CGFloat(shiftY + 12*deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + 4*deltaX), CGFloat(shiftY + 11*deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + deltaX), CGFloat(shiftY + 11*deltaY))
        CGPathAddLineToPoint(ref, nil, CGFloat(shiftX + deltaX), CGFloat(shiftY + deltaY))
        
        let wallLine = SKShapeNode()
        wallLine.path = ref
        wallLine.name = "wallLine"
        wallLine.strokeColor = UIColor.lightGrayColor()
        wallLine.lineWidth = 3
        wallLine.zPosition = 0
        
        self.addChild(wallLine)
    }
    
    func getNearestDotIndex(location: CGPoint) -> (Int, Int) {
        var betaX: Float = Float(location.x - CGFloat(shiftX)) / Float(deltaX)
        var betaY: Float = Float(location.y - CGFloat(shiftY)) / Float(deltaY)
        
        var indexX: Int = Int(round(betaX))
        var indexY: Int = Int(round(betaY))
        
        return (indexX, indexY)
    }
    
    func placeDot(locationIndex: (Int, Int)) -> Void {
        let sprite = SKSpriteNode(imageNamed:"DotAlice")
        
        sprite.xScale = 0.0
        sprite.yScale = 0.0
        sprite.position = CGPoint(
            x: Int(locationIndex.0 * deltaX + shiftX),
            y: Int(locationIndex.1 * deltaY + shiftY)
        )
        
        self.addChild(sprite)
        
        let action = SKAction.scaleTo(0.15, duration: 0.25)
        sprite.runAction(action)
    }
}
