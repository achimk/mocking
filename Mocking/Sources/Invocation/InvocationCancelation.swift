import Foundation

class InvocationCancelation {
    private let token: CancelToken
    var error: Error = CancelInvocationError()
    var isCanceled: Bool { token.isCanceled }

    init() {
        token = CancelToken()
    }

    init(_ token: CancelToken) {
        self.token = token
    }

    func cancel() {
        token.cancel(with: error)
    }
}
