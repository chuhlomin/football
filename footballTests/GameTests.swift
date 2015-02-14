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
//    [4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4],
//    [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
//    [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
//    [5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 6],
//    [5, 0, 0, 0, 0, 0, x, 0, 0, 0, 0, 0, 6],
//    [5, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 6],
//    [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
//    [4, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3, 4],
//    [4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4],
//    [4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4]
    
    override func setUp() {
        super.setUp()
        board = Board(width: 11, height: 13, goalMargin: 3)
        game = Game(board: board!)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testShouldSwitchPlayer() {
        game!.currentPlayer = game!.PLAYER_ALICE
        
        XCTAssertEqual(game!.PLAYER_BOB, game!.switchPlayer())
        XCTAssertEqual(game!.PLAYER_ALICE, game!.switchPlayer())
    }
    
    func testShouldDetermineWinnerAlice() {
        XCTAssertEqual(game!.PLAYER_BOB, game!.getWinner((4, 0))!)
    }
    
    func testShouldDetermineWinnerBob() {
        XCTAssertEqual(game!.PLAYER_ALICE, game!.getWinner((6, 12))!)
    }
    
    func testShouldDetectNowinner() {
        XCTAssertNil(game!.getWinner((3, 5)))
    }
    
    func testShouldDetermineIfMoveOver() {
        XCTAssertTrue(game!.isMoveOver((4, 4)))
    }
    
    func testShouldDetermineIfMoveNotOver() {
        XCTAssertFalse(game!.isMoveOver((1, 5)))
    }
    
    func testShouldDetermineIfMoveHasCorrectLenght() {
        XCTAssertFalse(game!.moveHasCorrectLenght((3, 4), pointTo: (3, 6)))
        XCTAssertFalse(game!.moveHasCorrectLenght((3, 4), pointTo: (1, 3)))
        XCTAssertTrue(game!.moveHasCorrectLenght((3, 4), pointTo: (3, 3)))
        XCTAssertTrue(game!.moveHasCorrectLenght((3, 4), pointTo: (3, 3)))
    }
}