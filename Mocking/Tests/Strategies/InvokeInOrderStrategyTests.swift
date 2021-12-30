import XCTest
@testable import Mocking

class InvokeInOrderStrategyTests: XCTestCase {

    func test_initialise_shouldBeEmpty() {
        let handler = InvokeInOrderStrategy<Int>()
        XCTAssertTrue(handler.answers.isEmpty)
        XCTAssertTrue(handler.completions.isEmpty)
    }

    func test_handleCompletionWhenAnswered_shouldBeInvoked() {
        let sink = CompletionSink<Result<Int, Error>>()
        let handler = InvokeInOrderStrategy<Int>()
        handler.answer(with: .success(1))

        _ = handler.handle(with: sink.on)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertEqual($0.value, 1)
        }
    }

    func test_handleCompletionWhenNotAnswered_shouldNotBeInvoked() {
        let sink = CompletionSink<Result<Int, Error>>()
        let handler = InvokeInOrderStrategy<Int>()

        _ = handler.handle(with: sink.on)

        assertInvoke(sink, count: 0)
    }

    func test_handleMultipleCompletions_shouldBeAnsweredInCorrectOrder() {
        let sink = CompletionSink<Result<Int, Error>>()
        let handler = InvokeInOrderStrategy<Int>()
        handler.answer(with: .success(1))
        handler.answer(with: .success(2))
        handler.answer(with: .success(3))
        handler.answer(with: .failure(TestError()))

        _ = handler.handle(with: sink.on)
        _ = handler.handle(with: sink.on)
        _ = handler.handle(with: sink.on)
        _ = handler.handle(with: sink.on)

        assertInvoke(sink, count: 4)

        assertPresent(sink.result(at: 0)) {
            XCTAssertEqual($0.value, 1)
        }

        assertPresent(sink.result(at: 1)) {
            XCTAssertEqual($0.value, 2)
        }

        assertPresent(sink.result(at: 2)) {
            XCTAssertEqual($0.value, 3)
        }

        assertPresent(sink.result(at: 3)) {
            XCTAssertNotNil($0.error as? TestError)
        }
    }

    func test_interruptWithCancelWhenNotAnswered_shouldBeInvoked() {
        let sink = CompletionSink<Result<Int, Error>>()
        let handler = InvokeInOrderStrategy<Int>()

        let token = handler.handle(with: sink.on)
        token.cancel(with: CancelError())

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertNotNil($0.error as? CancelError)
        }
    }

    func test_interruptWithCancelWhenAnswered_shouldBeIgnored() {
        let sink = CompletionSink<Result<Int, Error>>()
        let handler = InvokeInOrderStrategy<Int>()
        handler.answer(with: .success(1))

        let token = handler.handle(with: sink.on)
        token.cancel(with: CancelError())

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertEqual($0.value, 1)
        }
    }
}
