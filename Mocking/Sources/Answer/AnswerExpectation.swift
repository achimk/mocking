import Foundation

class AnswerExpectation<Output> {
    let notifyAnswer: (Result<Output, Error>) -> Void
    let handleWith: (@escaping Completion<Output>) -> Void
    let cancelWith: (Error) -> Void

    init<S>(strategy: S) where S: AnswerCompletionStrategy, S: HandleCompletionStrategy, S: CancelCompletionStrategy, S.Output == Output {
        notifyAnswer = strategy.answer(with:)
        handleWith = strategy.handle(with:)
        cancelWith = strategy.cancel(with:)
    }

    func success(_ value: Output) {
        notifyAnswer(.success(value))
    }

    func failure(_ error: Error) {
        notifyAnswer(.failure(error))
    }
}
