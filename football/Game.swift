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
    
    var board: Board
    var lastDot: (Int, Int)
    var currentPlayer: Int
    
    init(board: Board) {
        self.board = board
        currentPlayer = PLAYER_ALICE
        lastDot = board.getMiddleDotIndex()
        board.board[lastDot.0][lastDot.1] = currentPlayer
    }
    
    func makeMove(location: (Int, Int)) -> Bool {
        if isMovePossible(lastDot, pointTo: location) {
            
            board.addLine(lastDot, locationTo: location, player: currentPlayer)
            board.board[location.0][location.1] = currentPlayer
            
            lastDot = location
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
    
    func getWinner(lastDot: (Int, Int)) -> Int? {
        if board.getDot(lastDot) == board.GOAL_ALICE {
            return PLAYER_BOB
        }
        
        if board.getDot(lastDot) == board.GOAL_BOB {
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
}