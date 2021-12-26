import XCTest
@testable import Mocking

class InvocationConditionTests: XCTestCase {
    typealias MockTransformer = InvocationCondition<Int, String>

    // MARK: Mock Immediately Tests

    func test_mockImmediately_cancelShouldNotBeTakenIntoAccount() {

        let sink = CompletionSink<Result<String, Error>>()
        let mock = MockTransformer()
        mock.registerAny().thenSuccess("1")

        let cancelToken = mock.handle(1, completion: sink.on)
        cancelToken.cancel()

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isSuccess)
        }
    }

    // MARK: Mock Deferred Tests

    func test_mockDeferred_cancelShouldBeTakenIntoAccount() {

        let sink: SinkWithExpectation<Result<String, Error>> = makeSinkWithExpectation()
        let mock = MockTransformer()
        mock.registerAny().thenAfter(1, success: "1")

        let cancelToken = mock.handle(1, completion: sink.on)
        cancelToken.cancel()

        wait(for: sink, timeout: 3)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? CancelInvocationError)
        }
    }

    // MARK: Mock In Order Tests

    func test_mockInOrder_cancelShouldBeTakenIntoAccount() {

        let sink = CompletionSink<Result<String, Error>>()
        let mock = MockTransformer()
        let expectation = mock.registerAny().thenExpect()

        let cancelToken = mock.handle(1, completion: sink.on)
        cancelToken.cancel()
        expectation.success("1")

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? CancelInvocationError)
        }
    }
}
