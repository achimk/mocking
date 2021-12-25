import Foundation

class Answer<Output> {
    private(set) var handleWith: (@escaping Completion<Output>) -> CancelToken = { _ in CancelToken() }
}

// MARK: Immediate Answers

extension Answer {

    func then(_ completion: @escaping () throws -> Output) {
        let strategy = InvokeImediatelyStrategy(Result(catching: completion))
        handleWith = strategy.handle(with:)
    }

    func thenSuccess(_ value: Output) {
        then { value }
    }

    func thenFailure(_ error: Error) {
        then { throw error }
    }
}

// MARK: Deferred Answers

extension Answer {

    func thenAfter(_ timeout: TimeInterval, completion: @escaping () throws -> Output) {
        let strategy = InvokeDeferredStrategy(
            timeout: timeout,
            answerResult: Result(catching: completion))
        handleWith = strategy.handle(with:)
    }

    func thenAfter(_ timeout: TimeInterval, success value: Output) {
        thenAfter(timeout, completion: { value })
    }

    func thenAfter(_ timeout: TimeInterval, failure error: Error) {
        thenAfter(timeout, completion: { throw error })
    }
}

// MARK: Expected Answers

extension Answer {

    func thenExpect() -> AnswerExpectation<Output> {
        let strategy = InvokeInOrderStrategy<Output>()
        handleWith = strategy.handle(with:)
        return .init(consumeAnswer: strategy.answer(with:))
    }
}
