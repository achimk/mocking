import Foundation

class NopInvokeStrategy<Output>: HandleCompletionStrategy, AnswerCompletionStrategy {

    func answer(with result: InvocationResult<Output, Error>) {
        // No operation
    }

    func handle(with completion: @escaping InvocationCompletion<Output>) {
        // No operation
    }
}
