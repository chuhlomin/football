//
//  Board.swift
//  football
//
//  Created by Konstantin Chukhlomin on 13/02/15.
//  Copyright (c) 2015 Konstantin Chukhlomin. All rights reserved.
//

import Foundation

class Board {
    
    var board: Array<Array<Int>> = []
    var lines: Array<Line> = []
    
    var width: Int
    var height: Int
    var goalMargin: Int
    
    let EMPTY = 0
    let PLAYER_ALICE = 1
    let PLAYER_BOB = 2
    let WALL = 3
    let UNREACHABLE = 4
    let GOAL_ALICE = 5
    let GOAL_BOB = 6
    
    let LINE_WALL = 0
    let LINE_ALICE = 1
    let LINE_BOB = 2
    
    init(width: Int, height: Int, goalMargin: Int) {
        
        self.width = width - 1 // cuz we start from 0
        self.height = height - 1
        self.goalMargin = goalMargin
        
        fillBoardWithZero()
        fillBoardWalls()
        fillLines()
    }
    
    func fillBoardWithZero() {
        for indexX in 0...width {
            var columnArray = Array<Int>()
            
            for indexY in (0...height) {
                columnArray.append(EMPTY)
            }
            
            board.append(columnArray)
        }
    }
    
    func fillBoardWalls() {
        fillBoardWallVertical()
        fillBoardWallHorizontal()
        fillBoardGoal()
    }
    
    func fillBoardWallVertical() {
        for indexY in 0...height {
            board[0][indexY] = UNREACHABLE;
            board[width][indexY] = UNREACHABLE;
        }
        
        for indexY in 1...(height - 1) {
            board[1][indexY] = WALL;
            board[width - 1][indexY] = WALL;
        }
    }
    
    func fillBoardWallHorizontal() {
        for indexX in 0...width {
            board[indexX][0] = UNREACHABLE
            board[indexX][height] = UNREACHABLE
        }
        for indexX in 1...(width - 1) {
            board[indexX][1] = WALL
            board[indexX][height - 1] = WALL
        }
    }
    
    func fillBoardGoal() {        
        for indexX in (goalMargin + 1)...(width - goalMargin - 1) {
            board[indexX][0] = GOAL_ALICE
            board[indexX][height] = GOAL_BOB
        }
        
        if (goalMargin + 2) <= (width - goalMargin - 2) {
            for indexX in (goalMargin + 2)...(width - goalMargin - 2) {
                board[indexX][1] = EMPTY
                board[indexX][height - 1] = EMPTY
            }
        }
    }
    
    func fillLines() {
        fillLinesHorizontal()
        fillLinesVertical()
    }
    
    func fillLinesVertical() {
        for indexY in 0...(height - 1) {
            var x1 = 1
            var x2 = width - 1
            
            if (indexY == 0 || indexY == height - 1) {
                x1 = goalMargin + 1
                x2 = width - goalMargin - 1
            }
            
            lines.append(
                Line(
                    pointTo: (x1, indexY + 1),
                    pointFrom: (x1, indexY),
                    type: LINE_WALL
                )
            )
            lines.append(
                Line(
                    pointTo: (x2, indexY + 1),
                    pointFrom: (x2, indexY),
                    type: LINE_WALL
                )
            )
        }
    }
    
    func fillLinesHorizontal() {
        for indexX in 1...(width - 2) {
            var y1 = 1
            var y2 = height - 1
            
            if (indexX > (goalMargin + 1) && indexX < (width - goalMargin - 1)) {
                y1 = 0
                y2 = height
            }
            
            self.lines.append(
                Line(
                    pointTo: (indexX, 1),
                    pointFrom: (indexX + 1, 1),
                    type: LINE_WALL
                )
            )
            self.lines.append(
                Line(
                    pointTo: (indexX, height - 1),
                    pointFrom: (indexX + 1, height - 1),
                    type: LINE_WALL
                )
            )
        }
    }
    
    func getDot(location: (Int, Int)) -> Int? {
        if (location.0 < 0 || location.0 > width ||
            location.1 < 0 || location.1 > height) {
            return nil
        }
        
        return board[location.0][location.1]
    }
    
    func getMiddleDotIndex() -> (Int, Int) {
        return (Int(width / 2), Int(height / 2))
    }
    
    func addLine(locationFrom: (Int, Int), locationTo: (Int, Int), player: Int) -> Void {
        
        let line = Line(
            pointTo: locationTo,
            pointFrom: locationFrom,
            type: player
        )
        
        lines.append(line)
    }
}