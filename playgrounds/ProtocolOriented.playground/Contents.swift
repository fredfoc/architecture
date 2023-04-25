import Foundation

// Old School Inheritance

class Car {
    var color: Int
    var price: Int
    init(color: Int, price: Int) {
        self.color = color
        self.price = price
    }

    func switchOn() {}
}

class ElectricCar: Car {
    func charge() {}
}

class GasCar: Car {
    func refill() {}
}

// Protocol Oriented approach

protocol Car {
    var color: Int { get }
    var price: Int { get }
    init(color: Int, price: Int)
    func switchOn()
}

protocol Electric {
    func charge()
}

protocol Gas {
    func refill()
}
