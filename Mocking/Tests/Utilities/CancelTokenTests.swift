import XCTest
@testable import Mocking

class CancelTokenTests: XCTestCase {

    func test_initialiseWithoutCancelBlock_shouldBeCreatedCorreclty() {
        let token = CancelToken()
        XCTAssertFalse(token.isCanceled)
    }

    func test_initialiseWithCancelBlock_shouldBeCreatedCorretly() {
        let sink = CompletionSink<Error>()
        let token = CancelToken(cancelWith: sink.on)
        XCTAssertFalse(token.isCanceled)
    }

    func test_cancel_shouldBeCanceled() {
        let sink = CompletionSink<Error>()
        let token = CancelToken(cancelWith: sink.on)

        token.cancel(with: TestError())

        XCTAssertTrue(token.isCanceled)
    }

    func test_cancel_shouldBeInvoked() {
        let sink = CompletionSink<Error>()
        let token = CancelToken(cancelWith: sink.on)

        token.cancel(with: TestError())

        assertInvoke(sink, count: 1)
    }

    func test_cancel_shouldContainCorrectResult() {
        let sink = CompletionSink<Error>()
        let token = CancelToken(cancelWith: sink.on)

        token.cancel(with: TestError())

        assertPresent(sink.lastResult) {
            XCTAssertNotNil($0 as? TestError)
        }
    }

    func test_multipleCancel_shouldBeInvokedOnlyOnce() {
        let sink = CompletionSink<Error>()
        let token = CancelToken(cancelWith: sink.on)

        token.cancel(with: TestError())
        token.cancel(with: TestError())
        token.cancel(with: TestError())

        assertInvoke(sink, count: 1)
    }
}
