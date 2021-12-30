import XCTest
@testable import Mocking

class InvocationCompletionTests: XCTestCase {

    func test_invocationCompletion_shouldInvoke() {
        let sink = CompletionSink<Result<Int, Error>>()
        let completion = InvocationCompletion<Int>(completion: sink.on)

        completion.complete(with: .success(1))

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertEqual($0.value, 1)
        }
    }

    func test_invocationCompletion_shouldRunOnlyOnce() {
        let sink = CompletionSink<Result<Int, Error>>()
        let completion = InvocationCompletion<Int>(completion: sink.on)

        completion.complete(with: .success(1))
        completion.complete(with: .success(2))
        completion.complete(with: .success(3))

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertEqual($0.value, 1)
        }
    }
}
