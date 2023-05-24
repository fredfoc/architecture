import Foundation

// SRP

// Non compliant

struct Car {
    private var fuel: Int = 0
    private var speed: Int = 0
    private var internalTemp: Int = 20
    func displayFuel() -> Int {
        fuel
    }

    func displaySpeed() -> Int {
        speed
    }

    mutating func accelerate() {
        speed += 1
    }

    mutating func deccelerate() {
        speed -= 1
    }

    mutating func increaseInternalTemp() {
        internalTemp += 2
    }
}

// Compliant

struct Engine {
    private(set) var speed: Int = 0
    mutating func accelerate() {
        speed += 1
    }

    mutating func deccelerate() {
        speed -= 1
    }
}

struct FuelTank {
    private(set) var fuel: Int = 0
}

struct Heater {
    private(set) var internalTemp: Int = 20
    mutating func increaseInternalTemp() {
        internalTemp += 2
    }
}

struct SRPCar {
    let tachimetre: Engine
    let fuelTank: FuelTank
    let heater: Heater
}

// OCP

// Non compliant
enum BicycleType {
    case twoWheel
    case monoWheel
    case electrical
}

struct BadBicycle {
    let type: BicycleType
    var rentingPrice: Int {
        switch type {
        case .twoWheel:
            return 10
        case .monoWheel:
            return 12
        case .electrical:
            return 15
        }
    }
}

// Compliant

protocol Bicycle {
    var type: BicycleType { get }
    var rentingPrice: Int { get }
}

struct TwoWheelBicycle: Bicycle {
    let type = BicycleType.twoWheel
    var rentingPrice: Int { 10 }
}

// LSP

// Non Compliant

protocol ANiceProtocol {}
struct StructA: ANiceProtocol {}
struct StructB: ANiceProtocol {}

func doSomething(_ with: ANiceProtocol) {
    switch with {
    case is StructA:
        fatalError()
    default:
        print("ok")
    }
}

// Non Compliant

protocol Bird {
    func fly()
}

struct BlackBird: Bird {
    func fly() { print("I'm flying") }
}

struct Ostrich: Bird {
    func fly() { fatalError("won't fly") }
}

// ISP

// Non Compliant

protocol ATM {
    func deposit(amount: Int, account: Int)
    func withdrawal(amount: Int, account: Int)
    func balance(account: Int)
    func changePinCode(card: Int)
    func updateAddress(user: Int)
    func blockCard(id: Int)
    func contact(user: Int)
}

// Compliant

protocol Deposit {
    func deposit(amount: Int, account: Int)
}

protocol Withdrawal {
    func withdrawal(amount: Int, account: Int)
}

protocol AccountManagement {
    func balance(account: Int)
}

protocol CardManagement {
    func changePinCode(card: Int)
    func updateAddress(user: Int)
    func blockCard(id: Int)
    func contact(user: Int)
}
