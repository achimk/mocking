import XCTest
@testable import Mocking

class AnswerTests: XCTestCase {

    // MARK: Test initial

    func test_initialState_shouldReturnUnhandledError() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()

        _ = answer.handleWith(sink.on)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertNotNil(result.error as? UnhandledInvocationError)
        }

    }

    // MARK: Test immediate answers

    func test_immediateAnswerWithThrowingResult_shouldReturnAlways() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        answer.then { 1 }

        _ = answer.handleWith(sink.on)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertEqual(result.value, 1)
        }
    }

    func test_immediateAnswerWithSuccess_shouldReturnAlways() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        answer.thenSuccess(1)

        _ = answer.handleWith(sink.on)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertEqual(result.value, 1)
        }
    }

    func test_immediateAnswerWithFailure_shouldReturnAlways() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        answer.thenFailure(TestError())

        _ = answer.handleWith(sink.on)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertNotNil(result.error as? TestError)
        }
    }

    func test_immediateAnswerWithCancel_shouldBeIgnored() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        answer.then { 1 }

        let token = answer.handleWith(sink.on)
        token.cancel(with: CancelError())

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertEqual(result.value, 1)
        }
    }

    // MARK: Test deferred answers

    func test_deferredAnswerWithThrowingResult_shouldReturnAfterTimeout() {

        let sink: SinkWithExpectation<Result<Int, Error>> = makeSinkWithExpectation()
        let answer = Answer<Int>()
        answer.thenAfter(0, completion: { 1 })

        _ = answer.handleWith(sink.on)

        wait(for: sink, timeout: 3)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertEqual(result.value, 1)
        }
    }

    func test_deferredAnswerWithSuccess_shouldReturnAfterTimeout() {

        let sink: SinkWithExpectation<Result<Int, Error>> = makeSinkWithExpectation()
        let answer = Answer<Int>()
        answer.thenAfter(0, success: 1)

        _ = answer.handleWith(sink.on)

        wait(for: sink, timeout: 3)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertEqual(result.value, 1)
        }
    }

    func test_deferredAnswerWithFailure_shouldReturnAfterTimeout() {

        let sink: SinkWithExpectation<Result<Int, Error>> = makeSinkWithExpectation()
        let answer = Answer<Int>()
        answer.thenAfter(0, failure: TestError())

        _ = answer.handleWith(sink.on)

        wait(for: sink, timeout: 3)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertNotNil(result.error as? TestError)
        }
    }

    func test_deferredAnswerWithCancel_shouldNotBeIgnored() {

        let sink: SinkWithExpectation<Result<Int, Error>> = makeSinkWithExpectation()
        let answer = Answer<Int>()
        answer.thenAfter(0, completion: { 1 })

        let token = answer.handleWith(sink.on)
        token.cancel(with: CancelError())

        wait(for: sink, timeout: 3)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertNotNil(result.error as? CancelError)
        }
    }

    // MARK: Test expect answers

    func test_expectAnswer_shouldBeCalledAfterAnswer() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        let exp = answer.thenExpect()

        _ = answer.handleWith(sink.on)

        assertInvoke(sink, count: 0)
        exp.success(1)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertEqual(result.value, 1)
        }
    }

    func test_expectAnswerWithSuccess_shouldReturnWithCorrentAnswer() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        let exp = answer.thenExpect()
        exp.success(1)

        _ = answer.handleWith(sink.on)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertEqual(result.value, 1)
        }
    }

    func test_expectAnswerWithFailure_shouldReturnWithCorrentAnswer() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        let exp = answer.thenExpect()
        exp.failure(TestError())

        _ = answer.handleWith(sink.on)

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) { (result) in
            XCTAssertNotNil(result.error as? TestError)
        }
    }

    func test_expectAnswerWithMultipleAnswers_shouldReturnWithCorrentOrder() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        let exp = answer.thenExpect()
        exp.success(1)
        exp.success(2)
        exp.success(3)
        exp.failure(TestError())

        _ = answer.handleWith(sink.on)
        _ = answer.handleWith(sink.on)
        _ = answer.handleWith(sink.on)
        _ = answer.handleWith(sink.on)

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

    func test_expectAnswerWithCancel_shouldIgnoreCancelWhenAnswersNotEmpty() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        let exp = answer.thenExpect()

        let token = answer.handleWith(sink.on)

        exp.success(1)
        token.cancel(with: CancelError())

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertEqual($0.value, 1)
        }
    }

    func test_expectAnswerWithCancel_shouldCancelWhenAnswersAreEmpty() {

        let sink = CompletionSink<Result<Int, Error>>()
        let answer = Answer<Int>()
        _ = answer.thenExpect()

        let token = answer.handleWith(sink.on)
        token.cancel(with: CancelError())

        assertInvoke(sink, count: 1)
        assertPresent(sink.lastResult) {
            XCTAssertNotNil($0.error as? CancelError)
        }
    }
}
