import Foundation

public class InvocationCancelation {
    private let token: CancelToken
    private var handlers: [() -> Void] = []
    public var error: Error = CancelInvocationError()
    public var isCanceled: Bool { token.isCanceled }

    init(_ token: CancelToken = CancelToken()) {
        self.token = token
    }

    public func cancel() {
        guard !isCanceled else {
            return
        }

        token.cancel(with: error)
        handlers.forEach { $0() }
        handlers = []
    }

    public func onCancel(_ block: @escaping () -> Void) {
        if isCanceled {
            block()
        } else {
            handlers.append(block)
        }
    }
}
