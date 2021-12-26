import Foundation

class InvokeCounter {
    private(set) var count: Int = 0

    func increment() {
        count += 1
    }

    func reset() {
        count = 0
    }
}
