import Foundation

open class EventRecorder<Input: Equatable> {
    private var invokeByIdetifier: [String: InvokeCounter] = [:]
    private let invokeHistory = InvokeHistory<Input>()

    public init() { }
}

// MARK: Sink

extension EventRecorder {

    public func sink(_ input: Input) {
        let id = String(describing: input)
        let counter = invokeByIdetifier[id] ?? InvokeCounter()
        counter.increment()
        invokeByIdetifier[id] = counter
        invokeHistory.append(input)
    }
}

// MARK: Verify

extension EventRecorder {

    public func verify(_ input: Input, count: Int) -> Bool {
        let id = String(describing: input)
        return (invokeByIdetifier[id]?.count ?? 0) == count
    }

    public func verifyNever(_ input: Input) -> Bool {
        verify(input, count: 0)
    }

    public func verifyAny() -> Bool {
        return !invokeHistory.isEmpty
    }

    public func verifyAnyNever() -> Bool {
        return invokeHistory.isEmpty
    }

    public func verifyContains(_ input: Input) -> Bool {
        return invokeHistory.items.contains(input)
    }

    public func verifyInOrder(_ inputs: Input...) -> Bool {
        verifyInOrder(inputs)
    }

    public func verifyInOrder(_ inputs: [Input]) -> Bool {
        invokeHistory.items == inputs
    }
}

// MARK: Other

extension EventRecorder {

    public func reset() {
        invokeByIdetifier = [:]
        invokeHistory.reset()
    }
}
