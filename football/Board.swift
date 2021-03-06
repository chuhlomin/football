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
        fillBoardCorners()
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
    
    func fillBoardCorners() {
        board[1][1] = UNREACHABLE
        board[1][height - 1] = UNREACHABLE
        board[width - 1][1] = UNREACHABLE
        board[width - 1][height - 1] = UNREACHABLE
    }
    
    func fillLines() {
        fillLinesHorizontal()
        fillLinesVertical()
        fillLinesGoalExtra()
    }
    
    func fillLinesVertical() {
        for indexY in 0...(height - 1) {
            var x1 = 1
            var x2 = width - 1
            
            if (indexY == 0 || indexY == height - 1) {
                x1 = goalMargin + 1
                x2 = width - goalMargin - 1
            }
            
            addLine((x1, indexY), locationTo: (x1, indexY + 1), player: LINE_WALL)
            addLine((x2, indexY), locationTo: (x2, indexY + 1), player: LINE_WALL)
        }
    }
    
    func fillLinesHorizontal() {
        for indexX in 1...(width - 2) {
            var y1 = 1
            var y2 = height - 1
            
            if (indexX > goalMargin && indexX < (width - goalMargin - 1)) {
                y1 = 0
                y2 = height
            }
            
            addLine((indexX, y1), locationTo: (indexX + 1, y1), player: LINE_WALL)
            addLine((indexX, y2), locationTo: (indexX + 1, y2), player: LINE_WALL)
        }
    }
    
    func fillLinesGoalExtra() {
        // todo: make dynamic
        addLine((4, 0), locationTo: (3, 1), player: LINE_WALL)
        addLine((6, 0), locationTo: (7, 1), player: LINE_WALL)
        addLine((4, height), locationTo: (3, height - 1), player: LINE_WALL)
        addLine((6, height), locationTo: (7, height - 1), player: LINE_WALL)
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
    
    func searchLine(pointFrom: (Int, Int), pointTo: (Int, Int)) -> Line? {
        for line in lines {
            if (compareTuples(line.pointFrom, tupleTwo: pointFrom) &&
                compareTuples(line.pointTo, tupleTwo: pointTo)) {
                return line
            }
        
            if (compareTuples(line.pointFrom, tupleTwo: pointTo) &&
                compareTuples(line.pointTo, tupleTwo: pointFrom)) {
                return line
            }
        }

        return nil
    }
    
    func compareTuples(tupleOne: (Int, Int), tupleTwo: (Int, Int)) -> Bool {
        if (tupleOne.0 == tupleTwo.0 && tupleOne.1 == tupleTwo.1) {
            return true
        }
        
        return false
    }
}