import Foundation

class InvocationCondition<Input, Output> {
    private typealias Condition = (Input) -> Bool
    private typealias Invocation = (condition: Condition, answer: Answer<Output>)
    private var invocations: [Invocation] = []
}

extension InvocationCondition {

    func handle(_ input: Input, completion: @escaping Completion<Output>) -> InvocationCancelation {
        let completion = InvocationCompletion(completion: completion)

        for (condition, answer) in invocations {
            if condition(input) {
                answer.expectation.handleWith(completion.complete(with:))
                return InvocationCancelation {
                    answer.expectation.cancelWith(CancelInvocationError())
                }
            }
        }

        completion.complete(with: .failure(UnhandledInvocationError()))
        return InvocationCancelation()
    }
}

extension InvocationCondition {

    func when(_ condition: @escaping (Input) -> Bool) -> Answer<Output> {
        let invocation: Invocation = (condition, Answer())
        invocations.append(invocation)
        return invocation.answer
    }

    func whenAny() -> Answer<Output> {
        when { _ in true }
    }
}
