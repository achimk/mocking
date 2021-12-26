import Foundation

class InvokeHistory<T> {
    private(set) var items: [T] = []

    var isEmpty: Bool { return items.isEmpty }

    var last: T? { return items.last }

    func append(_ item: T) {
        items.append(item)
    }

    func reset() {
        items = []
    }
}
