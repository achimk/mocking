import Foundation

class InvokeAlwaysStrategy<Output>: HandleCompletionStrategy, AnswerCompletionStrategy, CancelCompletionStrategy {
    private var answerResult: Result<Output, Error>

    init(_ result: Result<Output, Error>) {
        answerResult = result
    }

    func answer(with result: Result<Output, Error>) {
        answerResult = result
    }

    func handle(with completion: @escaping Completion<Output>) {
        completion(answerResult)
    }

    func cancel(with error: Error) {
        // No operation
    }
}
