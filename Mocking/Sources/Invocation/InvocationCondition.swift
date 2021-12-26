import Foundation

class InvocationCondition<Input, Output> {
    private typealias Condition = (Input) -> Bool
    private typealias Invocation = (condition: Condition, answer: Answer<Output>)
    private var invocations: [Invocation] = []
}

// MARK: Register / Unregister

extension InvocationCondition {

    func register(_ condition: @escaping (Input) -> Bool) -> Answer<Output> {
        let invocation: Invocation = (condition, Answer())
        invocations.append(invocation)
        return invocation.answer
    }

    func registerAny() -> Answer<Output> {
        register { _ in true }
    }

    func unregisterAll() {
        invocations = []
    }
}

// MARK: Handle

extension InvocationCondition {

    func handle(_ input: Input, completion: @escaping Completion<Output>) -> InvocationCancelation {
        let completion = InvocationCompletion(completion: completion)

        for (condition, answer) in invocations {
            if condition(input) {
                let cancelToken = answer.handleWith(completion.complete(with:))
                return InvocationCancelation(cancelToken)
            }
        }

        completion.complete(with: .failure(UnhandledInvocationError()))
        return InvocationCancelation()
    }
}
