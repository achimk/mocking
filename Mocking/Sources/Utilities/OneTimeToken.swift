import Foundation

final class OneTimeToken {
    private let lock = NSLock()
    private(set) var isSealed = false

    func run(_ block: () -> Void) {
        guard !isSealed else {
            return
        }

        lock.lock()
        defer { lock.unlock() }

        guard !isSealed else {
            return
        }

        block()
        isSealed = true
    }
}
