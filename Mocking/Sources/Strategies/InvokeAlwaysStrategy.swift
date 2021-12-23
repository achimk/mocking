import Foundation

class InvokeAlwaysStrategy<Output>: HandleCompletionStrategy, AnswerCompletionStrategy {
    private var answerResult: InvocationResult<Output, Error>

    init(_ result: InvocationResult<Output, Error>) {
        answerResult = result
    }

    func answer(with result: InvocationResult<Output, Error>) {
        answerResult = result
    }

    func handle(with completion: @escaping InvocationCompletion<Output>) {
        completion(answerResult)
    }
}
