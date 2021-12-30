import XCTest
@testable import Mocking

class InvokeImmediatelyStrategyTests: XCTestCase {

    func test_initialiseWithResult_shouldContainValidAnswer() {
        let handler = InvokeImmediatelyStrategy(.success(1))
        XCTAssertEqual(handler.answerResult.value, 1)
    }

    func test_handleWithCompletion_shouldInvokeImmediately() {
        let sink = CompletionSink<Result<Int, Error>>()
        let handler = InvokeImmediatelyStrategy(.success(1))

        _ = handler.handle(with: sink.on)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertEqual($0.value, 1)
        }
    }
}
