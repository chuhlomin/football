//
//  Game.swift
//  football
//
//  Created by Konstantin Chukhlomin on 14/02/15.
//  Copyright (c) 2015 Konstantin Chukhlomin. All rights reserved.
//

import Foundation

class Game
{
    let PLAYER_ALICE = 1
    let PLAYER_BOB = 2
    
    var isRun: Bool
    var board: Board
    var lastDot: (Int, Int)
    var currentPlayer: Int
    var possibleMoves: [(Int, Int)] = []
    
    init(board: Board) {
        self.board = board
        currentPlayer = PLAYER_ALICE
        lastDot = board.getMiddleDotIndex()
        board.board[lastDot.0][lastDot.1] = currentPlayer
        self.isRun = false
        possibleMoves = getPossibleMoves()
    }
    
    func start() {
        isRun = true
    }
    
    func stop() {
        isRun = false
    }
    
    func makeMove(location: (Int, Int)) -> Bool {
        if !isRun {
            return false
        }
        
        let filtered = possibleMoves.filter { self.board.compareTuples($0, tupleTwo: location)}
        
        if (filtered.count > 0) {
            board.addLine(lastDot, locationTo: location, player: currentPlayer)
            board.board[location.0][location.1] = currentPlayer
            
            lastDot = location
            possibleMoves = getPossibleMoves()
            return true
        }
        
        return false
    }
    
    func isMovePossible(pointFrom: (Int, Int), pointTo: (Int, Int)) -> Bool {
        if (destinationIsReachable(pointTo) == false) {
            return false
        }
        
        if (moveHasCorrectLenght(pointFrom, pointTo: pointTo) == false) {
            return false
        }
        
        if (isLineExist(pointFrom, pointTo: pointTo) == true) {
            return false
        }
        
        return true
    }
    
    func moveHasCorrectLenght(pointFrom: (Int, Int), pointTo: (Int, Int)) -> Bool {
        if abs(pointFrom.0 - pointTo.0) > 1 {
            return false
        }
        
        if abs(pointFrom.1 - pointTo.1) > 1 {
            return false
        }
        
        if (pointFrom.0 - pointTo.0 == 0 &&
            pointFrom.1 - pointTo.1 == 0) {
            return false
        }
        
        return true
    }
    
    func isLineExist(pointFrom: (Int, Int), pointTo: (Int, Int)) -> Bool {
        if let line = board.searchLine(pointFrom, pointTo: pointTo) {
            return true
        }
        
        return false
    }
    
    func getPossibleMoves() -> [(Int, Int)] {
        var result: [(Int, Int)] = []
        for dX in -1...1 {
            for dY in -1...1 {
                if dX == 0 && dY == 0 {
                    continue
                }
                let nextDot = (lastDot.0 + dX, lastDot.1 + dY)
                
                if (isMovePossible(lastDot, pointTo: nextDot) == true) {
                    result.append(nextDot)
                    
                    if (dX > 0 && dY > 0) {
                        print("↗︎")
                    }
                    if (dX > 0 && dY < 0) {
                        print("↘︎")
                    }
                    if (dX > 0 && dY == 0) {
                        print("→")
                    }
                    if (dX == 0 && dY > 0) {
                        print("↑")
                    }
                    if (dX == 0 && dY < 0) {
                        print("↓")
                    }
                    if (dX < 0 && dY > 0) {
                        print("↖︎")
                    }
                    if (dX < 0 && dY < 0) {
                        print("↙︎")
                    }
                    if (dX < 0 && dY == 0) {
                        print("←")
                    }
                }
            }
        }
        println("")
        return result
    }
    
    func destinationIsReachable(destination: (Int, Int)) -> Bool {
        if (board.getDot(destination) == board.UNREACHABLE) {
            return false
        }
        
        return true
    }
    
    func isMoveOver(dot: Int) -> Bool {
        if (dot == board.EMPTY ||
            dot == board.GOAL_ALICE ||
            dot == board.GOAL_BOB) {
            return true
        }
        
        return false
    }
    
    func getWinner(dot: Int) -> Int? {
        if dot == board.GOAL_ALICE {
            return PLAYER_BOB
        }
        
        if dot == board.GOAL_BOB {
            return PLAYER_ALICE
        }
        
        return nil
    }
    
    func switchPlayer() -> Int {
        if currentPlayer == PLAYER_ALICE {
            currentPlayer = PLAYER_BOB
        } else {
            currentPlayer = PLAYER_ALICE
        }
        
        return currentPlayer
    }
    
    func restart() -> Void {
        currentPlayer = PLAYER_ALICE
        lastDot = board.getMiddleDotIndex()
        board.board[lastDot.0][lastDot.1] = currentPlayer
        possibleMoves = getPossibleMoves()
        self.isRun = true
    }
}