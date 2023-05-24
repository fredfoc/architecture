//
//  Decode.swift
//  TestsUnitaires
//
//  Created by B054WO on 22/05/2023.
//

import Foundation

struct GroceryProduct: Codable {
    let name: String
}

protocol Decoder {
    @discardableResult
    func decode<T>(_ type: T.Type, from data: Writable) throws -> T where T: Decodable
}

protocol Writable {
    func write(to url: URL) throws
}

extension Data: Writable {
    func write(to url: URL) throws {
        try write(to: url, options: [])
    }
}

extension JSONDecoder: Decoder {
    @discardableResult
    func decode<T>(_ type: T.Type, from data: Writable) throws -> T where T: Decodable {
        guard let data = data as? Data else {
            fatalError("oups")
        }
        return try decode(type, from: data)
    }
}

class ManagerExercice {
    func decodeAndSave(from json: Writable, to path: URL, decoder: Decoder = JSONDecoder()) -> Error? {
        do {
            try decoder.decode(GroceryProduct.self, from: json)
            try json.write(to: path)
            return nil
        } catch {
            return error
        }
    }
}
