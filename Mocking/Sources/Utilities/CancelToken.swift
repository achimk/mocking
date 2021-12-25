import Foundation

class CancelToken {
    private let token = OneTimeToken()
    private let cancelWith: (Error) -> Void
    var isCanceled: Bool { token.isSealed }

    init(cancelWith: @escaping (Error) -> Void = { _ in }) {
        self.cancelWith = cancelWith
    }

    func cancel(with error: Error) {
        token.run {
            cancelWith(error)
        }
    }
}
