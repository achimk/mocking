import Foundation

protocol HandleCompletionStrategy {
    associatedtype Output
    func handle(with completion: @escaping InvocationCompletion<Output>)
}
