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
    }
    
    func makeMove(location: (Int, Int)) -> Bool {
        let liveAdded = board.addLine(lastDot, locationTo: location, player: currentPlayer)
        if !liveAdded {
            return false
        }
        
        lastDot = location
        return true
    }
    
    func isMoveOver() -> Bool {
        return true
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