import Foundation

var greeting = "Hello, playground"

func IHaveASideEffect(_ value: String) {
    greeting = value
}

print(greeting)
IHaveASideEffect("Hello Fred")
print(greeting)
