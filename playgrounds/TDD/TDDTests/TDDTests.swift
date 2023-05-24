//
//  TDDTests.swift
//  TDDTests
//
//  Created by B054WO on 23/05/2023.
//

@testable import TDD
import XCTest

final class TDDTests: XCTestCase {
    func testSum1() throws {
        // arrange
        // act
        // assert
        XCTAssertEqual(sum(2, 3), 5)
    }

    func testSum2() throws {
        // arrange
        let x = 2
        let y = 5
        let expectedResult = 7
        // act
        let result = sum(x, y)
        // assert
        XCTAssertEqual(result, expectedResult)
    }

    func testSum3() throws {
        // arrange
        let x = Int.random(in: 3 ..< 20)
        let y = Int.random(in: 8 ..< 20)
        let expectedResult = x + y
        // act
        let result = sum(x, y)
        // assert
        XCTAssertEqual(result, expectedResult)
    }
}
