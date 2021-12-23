import Foundation

class AnswerExpectation<Output> {
    let notifyAnswer: (InvocationResult<Output, Error>) -> Void
    let handleWith: (@escaping InvocationCompletion<Output>) -> Void

    init<S>(strategy: S) where S: AnswerCompletionStrategy, S.Answer == Output, S: HandleCompletionStrategy, S.Output == Output {
        notifyAnswer = strategy.answer(with:)
        handleWith = strategy.handle(with:)
    }

    func success(_ value: Output) {
        notifyAnswer(.success(value))
    }

    func failure(_ error: Error) {
        notifyAnswer(.failure(error))
    }
}
