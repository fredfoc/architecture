import Foundation

let isNotClean = true
// not clean code
if !isNotClean {
    print("I am clean")
}

// clean code
let isClean = !isNotClean
if isClean {
    print("I am clean")
}

struct Journey {
    let time: Float
    let averageSpeed: Float
}

struct Car {
    let costPerKilometre: Float
}

func calculateFuelCost(journey: Journey, car: Car) -> Float {
    let journeyTime = journey.time
    let averageSpeed = journey.averageSpeed
    let distance = calculateDistanceTravelled(journeyTime, averageSpeed)
    return car.costPerKilometre * distance
}

func calculateDistanceTravelled(_ journeyTime: Float, _ averageSpeed: Float) -> Float {
    journeyTime * averageSpeed
}
