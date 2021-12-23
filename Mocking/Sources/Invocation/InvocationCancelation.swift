import Foundation

class InvocationCancelation {
    private let token = OneTimeToken()
    private let onCancel: () -> ()
    var isCanceled: Bool { token.isSealed }

    init(onCancel: @escaping () -> () = { }) {
        self.onCancel = onCancel
    }

    func cancel() {
        token.run(onCancel)
    }
}
