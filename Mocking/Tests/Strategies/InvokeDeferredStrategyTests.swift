import XCTest
@testable import Mocking

class InvokeDeferredStrategyTests: XCTestCase {

    func test_initialiseWithResult_shouldContainValidAnswer() {
        let handler = InvokeDeferredStrategy(
            timeout: 100,
            answerResult: .success(1))

        XCTAssertEqual(handler.answerResult.value, 1)
        XCTAssertEqual(handler.timeout, 100)
    }

    func test_handleCompletion_shouldInvokeAfterTimeout() {
        let sink: SinkWithExpectation<Result<Int, Error>> = makeSinkWithExpectation()
        let handler = InvokeDeferredStrategy(
            timeout: 0,
            answerResult: .success(1))

        _ = handler.handle(with: sink.on)

        wait(for: sink, timeout: 3)

        assertPresent(sink.lastResult) {
            XCTAssertEqual($0.value, 1)
        }
    }

    func test_interruptWithCancel_shouldInvokeAfterCancel() {

        let sink: SinkWithExpectation<Result<Int, Error>> = makeSinkWithExpectation()
        let handler = InvokeDeferredStrategy(
            timeout: 0,
            answerResult: .success(1))

        let token = handler.handle(with: sink.on)
        token.cancel(with: TestError())

        wait(for: sink, timeout: 3)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertNotNil($0.error as? TestError)
        }
    }
}
