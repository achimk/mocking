import Foundation

protocol CancelCompletionStrategy {
    func cancel(with error: Error)
}
