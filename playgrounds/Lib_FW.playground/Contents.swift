import Foundation

struct GroceryProduct: Codable {
    var name: String
    var points: Int
    var description: String?
}

let json = """
{
    "name": "Durian",
    "points": 600,
    "description": "A fruit with a distinctive scent."
}
""".data(using: .utf8)!

/*
 class Manager {
     // Strong dependency to Foundation/JSONDecoder
     let decoder = JSONDecoder()
     func printName(from json: Data) {
         let product = try? decoder.decode(GroceryProduct.self, from: json)
         print(product?.name ?? "oups")
     }
 }

 let manager = Manager()
 manager.printName(from: json) // Prints "Durian"
 */

//

protocol JSONDecoderProtocol {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: JSONDecoderProtocol {}

class Manager {
    // Strong dependency to Foundation/JSONDecoder
    let decoder: JSONDecoderProtocol
    init(decoder: JSONDecoderProtocol) {
        self.decoder = decoder
    }

    func printName(from json: Data) {
        let product = try? decoder.decode(GroceryProduct.self, from: json)
        print(product?.name ?? "oups")
    }
}

let manager = Manager(decoder: JSONDecoder())
manager.printName(from: json) // Prints "Durian"

// Exercice

class ManagerExercice {
    func decodeAndSave(from json: Data, to path: URL) throws {
        try JSONDecoder().decode(GroceryProduct.self, from: json)
        try json.write(to: path)
    }
}
