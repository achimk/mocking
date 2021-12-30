import Foundation

open class TypeRecorder {
    private var invokeByIdetifier: [String: InvokeCounter] = [:]
    private let invokeHistory = InvokeHistory<String>()

    public init() { }
}

// MARK: Sink

extension TypeRecorder {

    public func sink<Input>(_ input: Input.Type) {
        let id = String(describing: input)
        let counter = invokeByIdetifier[id] ?? InvokeCounter()
        counter.increment()
        invokeByIdetifier[id] = counter
        invokeHistory.append(id)
    }
}

// MARK: Verify

extension TypeRecorder {

    public func verify<Input>(_ input: Input.Type, count: Int) -> Bool {
        let id = String(describing: input)
        return (invokeByIdetifier[id]?.count ?? 0) == count
    }

    public func verifyNever<Input>(_ input: Input.Type) -> Bool {
        verify(input, count: 0)
    }

    public func verifyAny() -> Bool {
        return !invokeHistory.isEmpty
    }

    public func verifyAnyNever() -> Bool {
        return invokeHistory.isEmpty
    }

    public func verifyContains<Input>(_ input: Input.Type) -> Bool {
        let id = String(describing: input)
        return invokeHistory.items.contains(id)
    }

    public func verifyInOrder(_ inputs: Any...) -> Bool {
        verifyInOrder(inputs)
    }

    public func verifyInOrder(_ inputs: [Any]) -> Bool {
        invokeHistory.items == inputs.map { String(describing: $0) }
    }
}

// MARK: Other

extension TypeRecorder {

    public func reset() {
        invokeByIdetifier = [:]
        invokeHistory.reset()
    }
}
