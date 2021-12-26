import Foundation

public class Answer<Output> {
    private(set) var handleWith: (@escaping Completion<Output>) -> CancelToken = { _ in CancelToken() }
}

// MARK: Immediate Answers

extension Answer {

    public func then(_ completion: @escaping () throws -> Output) {
        let strategy = InvokeImediatelyStrategy(Result(catching: completion))
        handleWith = strategy.handle(with:)
    }

    public func thenSuccess(_ value: Output) {
        then { value }
    }

    public func thenFailure(_ error: Error) {
        then { throw error }
    }
}

// MARK: Deferred Answers

extension Answer {

    public func thenAfter(_ timeout: TimeInterval, completion: @escaping () throws -> Output) {
        let strategy = InvokeDeferredStrategy(
            timeout: timeout,
            answerResult: Result(catching: completion))
        handleWith = strategy.handle(with:)
    }

    public func thenAfter(_ timeout: TimeInterval, success value: Output) {
        thenAfter(timeout, completion: { value })
    }

    public func thenAfter(_ timeout: TimeInterval, failure error: Error) {
        thenAfter(timeout, completion: { throw error })
    }
}

// MARK: Expected Answers

extension Answer {

    public func thenExpect() -> AnswerExpectation<Output> {
        let strategy = InvokeInOrderStrategy<Output>()
        handleWith = strategy.handle(with:)
        return .init(consumeAnswer: strategy.answer(with:))
    }
}
