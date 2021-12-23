import Foundation

class InvocationCancelable {
    private let onCancel: () -> ()
    private(set) var isCanceled: Bool = false

    init(onCancel: @escaping () -> () = { }) {
        self.onCancel = onCancel
    }

    func cancel() {
        if !isCanceled {
            isCanceled = true
            cancel()
        }
    }
}
