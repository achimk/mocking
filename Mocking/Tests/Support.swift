import Foundation
import XCTest

struct TestError: Error { }

struct CancelError: Error { }

class CompletionSink<T> {
    private(set) var isInvoked: Bool = false
    private(set) var invokeCount: Int = 0
    private(set) var results: [T] = []
//    private var handlers: [() -> Void] = []

    var lastResult: T? { results.last }

//    func notify(_ handler: @escaping () -> Void) {
//        handlers.append(handler)
//    }

    func on(_ result: T) {
        isInvoked = true
        invokeCount += 1
        results.append(result)
//        handlers.forEach { $0() }
    }

    func reset() {
        isInvoked = false
        invokeCount = 0
        results = []
    }
}

class SinkWithExpectation<T>: CompletionSink<T> {
    private let expectationFactory: () -> XCTestExpectation
    private(set) var expectation: XCTestExpectation

    init(expectationFactory: @escaping () -> XCTestExpectation) {
        self.expectationFactory = expectationFactory
        expectation = expectationFactory()
    }

    override func on(_ result: T) {
        super.on(result)
        expectation.fulfill()
    }

    override func reset() {
        super.reset()
        expectation = expectationFactory()
    }
}

extension Result {

    var isSuccess: Bool {
        switch self {
        case .success: return true
        case .failure: return false
        }
    }

    var isFailure: Bool {
        return !isSuccess
    }

    var value: Success? {
        if case .success(let value) = self {
            return value
        } else {
            return nil
        }
    }

    var error: Failure? {
        if case .failure(let error) = self {
            return error
        } else {
            return nil
        }
    }
}

extension XCTestCase {

    func assertPresent<T>(_ value: T?, then: (T) -> (), file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertNotNil(value, file: file, line: line)
        if let value = value {
            then(value)
        }
    }

    func assertInvoke<T>(_ sink: CompletionSink<T>, count: Int,  file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertEqual(sink.invokeCount, count, "Invoke count doesn't match: \(sink.invokeCount) != \(count)")
    }
}


extension XCTestCase {

    func makeSinkWithExpectation<T>(
        description: String = "Completion expectation",
        when condition: @escaping (CompletionSink<T>) -> Bool = { _ in true }) -> SinkWithExpectation<T> {

        let factory = { [weak self] in
            return self?.expectation(description: description) ?? undefined()
        }
        return SinkWithExpectation<T>(expectationFactory: factory)
    }

    func wait<T>(for sink: SinkWithExpectation<T>, timeout seconds: TimeInterval) {
        wait(for: [sink.expectation], timeout: seconds)
    }
}

func undefined<T>() -> T {
    fatalError()
}
