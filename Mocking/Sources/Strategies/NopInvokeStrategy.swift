import Foundation

class NopInvokeStrategy<Output>: HandleCompletionStrategy, AnswerCompletionStrategy, CancelCompletionStrategy {

    func answer(with result: Result<Output, Error>) {
        // No operation
    }

    func handle(with completion: @escaping Completion<Output>) {
        // No operation
    }

    func cancel(with error: Error) {
        // No operation
    }
}
