import Foundation

public struct InvokeParams<Input> {
    public let count: Int
    public let last: Input?
    public let input: Input
}

open class MockResource<Input: Equatable, Output> {
    private let invokeCounter = InvokeCounter()
    private let invokeHistory = InvokeHistory<Input>()
    private let conditions = InvocationCondition<InvokeParams<Input>, Output>()

    public init() { }
}

// MARK: Handle

extension MockResource {

    @discardableResult
    public func handle(
        _ input: Input,
        completion: @escaping (Result<Output, Error>) -> Void) -> InvocationCancelation {

        invokeCounter.increment()

        let params = InvokeParams(
            count: invokeCounter.count,
            last: invokeHistory.last,
            input: input)

        invokeHistory.append(input)

        return conditions.handle(params, completion: completion)
    }
}

// MARK: Conditions

extension MockResource {

    public func when(_ condition: @escaping (InvokeParams<Input>) -> Bool) -> Answer<Output> {
        conditions.register(condition)
    }

    public func whenAny() -> Answer<Output> {
        conditions.registerAny()
    }
}

// MARK: Verify

extension MockResource {

    public func verify(count: Int) -> Bool {
        invokeCounter.count == count
    }

    public func verifyNever() -> Bool {
        invokeHistory.isEmpty
    }

    public func verifyInOrder(_ inputs: Input...) -> Bool {
        verifyInOrder(inputs)
    }

    public func verifyInOrder(_ inputs: [Input]) -> Bool {
        invokeHistory.items == inputs
    }

    public func verifyContains(_ input: Input) -> Bool {
        invokeHistory.items.contains(input)
    }
}

// MARK: Others

extension MockResource {

    public func reset() {
        invokeCounter.reset()
        invokeHistory.reset()
    }

    public func clearConditions() {
        conditions.unregisterAll()
    }
}
