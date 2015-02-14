//
//  Board.swift
//  football
//
//  Created by Konstantin Chukhlomin on 13/02/15.
//  Copyright (c) 2015 Konstantin Chukhlomin. All rights reserved.
//

import XCTest

class BoardTests: XCTestCase {
    
    func testShouldCreateSmallBoard() {
        var board = Board(width: 6, height: 6, goalMargin: 1)

        let expectedBoard = [
            [4, 4, 4, 4, 4, 4],
            [4, 3, 3, 3, 3, 4],
            [5, 3, 0, 0, 3, 6],
            [5, 3, 0, 0, 3, 6],
            [4, 3, 3, 3, 3, 4],
            [4, 4, 4, 4, 4, 4]
        ]
        
        XCTAssertEqual(expectedBoard, board.board)
        
        let expectedLines: Array<(Dot, Dot, Int)> = []
        
        XCTAssertEqual(16, board.lines.count)
    }
    
    func testShouldCreateLargeBoard() {
        var board = Board(width: 11, height: 13, goalMargin: 3)
        
        let expectedBoard = [
            [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
            [4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4],
            [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
            [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
            [5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 6],
            [5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 6],
            [5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 6],
            [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
            [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
            [4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4],
            [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]
        ]
        
        XCTAssertEqual(expectedBoard, board.board)
    }
}
