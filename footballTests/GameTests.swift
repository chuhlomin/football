//
//  GameTests.swift
//  football
//
//  Created by Konstantin Chukhlomin on 15/02/15.
//  Copyright (c) 2015 Konstantin Chukhlomin. All rights reserved.
//

import XCTest

class GameTests: XCTestCase {
    
    var game: Game?
    var board: Board?
//    [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4],
//    [4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4],
//    [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
//    [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
//    [5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 6],
//    [5, 0, 0, 0, 0, 0, x, 0, 0, 0, 0, 0, 6],
//    [5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 6],
//    [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
//    [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
//    [4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4],
//    [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]
    
    override func setUp() {
        super.setUp()
        board = Board(width: 11, height: 13, goalMargin: 3)
        game = Game(board: board!)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testShouldSwitchPlayer() {
        game!.currentPlayer = game!.PLAYER_ALICE
        
        XCTAssertEqual(game!.PLAYER_BOB, game!.switchPlayer())
        XCTAssertEqual(game!.PLAYER_ALICE, game!.switchPlayer())
    }
    
    func testShouldDetermineWinner() {
        XCTAssertEqual(game!.PLAYER_BOB, game!.getWinner(board!.GOAL_ALICE)!)
        XCTAssertEqual(game!.PLAYER_ALICE, game!.getWinner(board!.GOAL_BOB)!)
        XCTAssertNil(game!.getWinner(board!.EMPTY))
    }
    
    func testShouldDetermineIfMoveNotOver() {
        XCTAssertTrue(game!.isMoveOver(0))
        XCTAssertFalse(game!.isMoveOver(3))
    }
    
    func testShouldDetermineIfMoveHasCorrectLenght() {
        XCTAssertFalse(game!.moveHasCorrectLenght((3, 4), pointTo: (3, 6)))
        XCTAssertFalse(game!.moveHasCorrectLenght((3, 4), pointTo: (1, 3)))
        XCTAssertTrue(game!.moveHasCorrectLenght((3, 4), pointTo: (3, 3)))
        XCTAssertTrue(game!.moveHasCorrectLenght((3, 4), pointTo: (3, 3)))
    }
    
    func testShouldGetPossibleMovesInGeneralCase() {
        game!.lastDot = (5, 6)
        XCTAssertEqual(8, game!.getPossibleMoves().count)
    }
    
    func testShouldGetPossibleMovesNearTheWall() {
        game!.lastDot = (1, 6)
        XCTAssertEqual(3, game!.getPossibleMoves().count)
    }
    
    func testShouldGetPossibleMovesNearTheCorner() {
        game!.lastDot = (2, 2)
        XCTAssertEqual(7, game!.getPossibleMoves().count)
    }
    
    func testShouldGetPossibleMovesInTheCorner() {
        game!.lastDot = (1, 1)
        XCTAssertEqual(1, game!.getPossibleMoves().count)
    }

    func testShouldGetPossibleMovesNearTheGoal() {
        game!.lastDot = (4, 1)
        XCTAssertEqual(5, game!.getPossibleMoves().count)
    }
}