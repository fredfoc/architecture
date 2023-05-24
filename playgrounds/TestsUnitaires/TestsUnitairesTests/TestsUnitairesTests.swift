//
//  TestsUnitairesTests.swift
//  TestsUnitairesTests
//
//  Created by B054WO on 22/05/2023.
//

@testable import TestsUnitaires
import XCTest

final class TestsUnitairesTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExampleSuccess() throws {
        // arrange
        class MockWritable: Writable {
            func write(to _: URL) throws {}
        }
        class MockDecoder: Decoder {
            func decode<T>(_: T.Type, from _: TestsUnitaires.Writable) throws -> T where T: Decodable {
                guard let grocery = GroceryProduct(name: "Fred") as? T else {
                    fatalError()
                }
                return grocery
            }
        }
        let data = MockWritable()
        let decoder = MockDecoder()
        // act
        let result = ManagerExercice().decodeAndSave(from: data, to: URL(fileURLWithPath: #file), decoder: decoder)
        // assert
        XCTAssertNil(result)
    }

    func testErreurDecoder() throws {
        // arrange
        class MockWritable: Writable {
            func write(to _: URL) throws {}
        }
        enum MyError: Error {
            case test
        }
        class MockDecoder: Decoder {
            func decode<T>(_: T.Type, from _: TestsUnitaires.Writable) throws -> T where T: Decodable {
                throw MyError.test
            }
        }
        let data = MockWritable()
        let decoder = MockDecoder()
        // act
        let result = ManagerExercice().decodeAndSave(from: data, to: URL(fileURLWithPath: #file), decoder: decoder)
        // assert
        XCTAssertTrue(result as? MyError == MyError.test)
    }
}
