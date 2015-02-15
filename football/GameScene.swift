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
    var radialAlice: SKSpriteNode?;
    var radialBob: SKSpriteNode?;
    
    override func didMoveToView(view: SKView) {
        let boardWidth = 11
        let boardHeight = 13
        let board = Board(width: boardWidth, height: boardHeight, goalMargin: 3)
        self.game = Game(board: board)
        
        calcDeltaAndShift(board)
        drawDotsZero(board)
        drawWall()
        
        placeDot(game!.lastDot)
        
        initRadials()
        activateCurrentRadial()
        
        game?.start()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            let locationIndex = self.getNearestDotIndex(location)
            
            if let currentDot = game?.board.getDot(locationIndex) {
                let previousDot = game?.lastDot
                if (game?.makeMove(locationIndex) != false) {
                    
                    drawLine(previousDot!, pointTo: locationIndex, player: game!.currentPlayer)
                    
                    if (currentDot != game?.board.PLAYER_ALICE &&
                        currentDot != game?.board.PLAYER_BOB) {
                        placeDot(locationIndex)
                    }
                    
                    if (game?.isMoveOver(currentDot) == true) {
                        game?.switchPlayer()
                        activateCurrentRadial()
                    }
                    
                    if let winner = game!.getWinner(currentDot) {
                        game?.stop()
                        showWinner(winner)
                    }
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
        CGPathMoveToPoint(ref, nil, getPontXByIndex(1), getPontYByIndex(1))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(4), getPontYByIndex(1))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(4), getPontYByIndex(0))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(6), getPontYByIndex(0))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(6), getPontYByIndex(1))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(9), getPontYByIndex(1))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(9), getPontYByIndex(11))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(6), getPontYByIndex(11))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(6), getPontYByIndex(12))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(4), getPontYByIndex(12))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(4), getPontYByIndex(11))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(1), getPontYByIndex(11))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(1), getPontYByIndex(1))
        
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
        let sprite = (game?.currentPlayer == game?.PLAYER_ALICE)
            ? SKSpriteNode(imageNamed:"DotAlice")
            : SKSpriteNode(imageNamed:"DotBob")
        
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
    
    func drawLine(pointFrom: (Int, Int), pointTo: (Int, Int), player: (Int)) -> Void {
        
        let playerColor = (player == game?.PLAYER_ALICE)
            ? UIColor(red:0.29, green:0.56, blue:0.89, alpha:1)
            : UIColor(red:0.95, green:0.65, blue:0.21, alpha:1)
        
        var ref = CGPathCreateMutable()
        CGPathMoveToPoint(ref, nil, getPontXByIndex(pointFrom.0), getPontYByIndex(pointFrom.1))
        CGPathAddLineToPoint(ref, nil, getPontXByIndex(pointTo.0), getPontYByIndex(pointTo.1))
        
        let line = SKShapeNode(path: ref)
        line.strokeColor = playerColor
        line.lineWidth = 3
        line.zPosition = 0
        line.alpha = 0
        
        self.addChild(line)
        
        let action = SKAction.fadeAlphaTo(1, duration: 0.25)
        line.runAction(action)
    }
    
    func getPontXByIndex(indexX: Int) -> CGFloat {
        return CGFloat(shiftX + indexX * deltaX)
    }
    
    func getPontYByIndex(indexY: Int) -> CGFloat {
        return CGFloat(shiftY + indexY * deltaY)
    }
    
    func initRadials() {
        radialAlice = SKSpriteNode(imageNamed:"RadialAlice")
        radialAlice?.yScale = 0.33
        radialAlice?.alpha = 0
        radialAlice?.zRotation = CGFloat(M_PI)
        radialAlice?.position = CGPoint(
            x: self.frame.width / 2,
            y: radialAlice!.size.height / 3
        )
        
        self.addChild(radialAlice!)
        
        radialBob = SKSpriteNode(imageNamed:"RadialBob")
        radialBob?.yScale = 0.33
        radialBob?.alpha = 0
        radialBob?.position = CGPoint(
            x: self.frame.width / 2,
            y: self.frame.height - radialBob!.size.height / 3
        )
        
        self.addChild(radialBob!)
    }
    
    func activateCurrentRadial() {
        let actionFadeIn = SKAction.fadeAlphaTo(1, duration: 0.5)
        let actionFadeOut = SKAction.fadeAlphaTo(0, duration: 0.5)
        
        if (game?.currentPlayer == game?.PLAYER_ALICE) {
            radialAlice?.runAction(actionFadeIn)
            radialBob?.runAction(actionFadeOut)
        } else {
            radialAlice?.runAction(actionFadeOut)
            radialBob?.runAction(actionFadeIn)
        }
    }
    
    func showWinner(winner: Int) {
        let whiteBg = SKSpriteNode(imageNamed: "Transparent")
        whiteBg.size.width = frame.width
        whiteBg.size.height = frame.height
        whiteBg.zPosition = 9
        whiteBg.position = CGPoint(
            x: CGRectGetMidX(self.frame),
            y: CGRectGetMidY(self.frame)
        )
        self.addChild(whiteBg)
        
        let labelWin = SKLabelNode(fontNamed: "AvenirNext-Medium")
        labelWin.text = "win!";
        labelWin.fontSize = 65;
        labelWin.fontColor = UIColor.blackColor()
        labelWin.zPosition = 10
        labelWin.position = CGPoint(
            x: CGRectGetMidX(self.frame),
            y: CGRectGetMidY(self.frame)
        );
        self.addChild(labelWin)
        
        let winnerImage = (winner == game?.PLAYER_ALICE) ? "DotAlice" : "DotBob"
        
        let circleWin = SKSpriteNode(imageNamed: winnerImage)
        circleWin.zPosition = 10
        circleWin.position = CGPoint(
            x: CGRectGetMidX(self.frame),
            y: CGRectGetMidY(self.frame) + 100
        )
        self.addChild(circleWin)
    }
}
