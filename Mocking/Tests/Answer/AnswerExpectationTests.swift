import XCTest
@testable import Mocking

class AnswerExpectationTests: XCTestCase {

    func test_consumeSuccess_shouldInvokeCompletion() {
        let sink = CompletionSink<Result<Int, Error>>()
        let exp = AnswerExpectation(consumeAnswer: sink.on)

        exp.success(1)

        assertInvoke(sink, count: 1)
        assertPresent(sink.firstResult) { (result) in
            assertPresent(result.value) { (value) in
                XCTAssertEqual(value, 1)
            }
        }
    }

    func test_consumeFailure_shouldInvokeCompletion() {
        let sink = CompletionSink<Result<Int, Error>>()
        let exp = AnswerExpectation(consumeAnswer: sink.on)

        exp.failure(TestError())

        assertInvoke(sink, count: 1)
        assertPresent(sink.firstResult) { (result) in
            assertPresent(result.error) { (error) in
                XCTAssertNotNil(error as? TestError)
            }
        }
    }
}
