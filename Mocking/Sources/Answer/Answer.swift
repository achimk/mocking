import Foundation

class Answer<Output> {
    private(set) var expectation: AnswerExpectation<Output> = .init(strategy: NopInvokeStrategy())

    func then(_ completion: @escaping () throws -> Output) {
        let strategy = InvokeAlwaysStrategy(InvocationResult(catching: completion))
        expectation = AnswerExpectation(strategy: strategy)
    }

    func thenSuccess(_ value: Output) {
        then { value }
    }

    func thenFailure(_ error: Error) {
        then { throw error }
    }

    func thenExpect() -> AnswerExpectation<Output> {
        expectation = AnswerExpectation(strategy: InvokeInOrderStrategy())
        return expectation
    }
}
