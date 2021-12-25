import XCTest
@testable import Mocking

// MARK: Implementation

protocol AsyncCancelable {
    func cancel()
}

protocol AsyncTransformable {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input, completion: @escaping Completion<Output>) -> AsyncCancelable
}

// MARK: Mocks for Implementation

extension InvocationCancelation: AsyncCancelable { }

final class MockTransformer: InvocationCondition<Int, String>, AsyncTransformable {

    func transform(_ input: Int, completion: @escaping Completion<String>) -> AsyncCancelable {
        return handle(input, completion: completion)
    }
}

// MARK: Tests

class InvocationConditionTests: XCTestCase {

}

// MARK: Mock Immediately Tests

extension InvocationConditionTests {

    func test_mockImmediately_cancelShouldNotBeTakenIntoAccount() {

        let sink = CompletionSink<Result<String, Error>>()
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        let cancelToken = mock.transform(1, completion: sink.on)
        cancelToken.cancel()

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isSuccess)
        }
    }
}

// MARK: Mock Deferred Tests

extension InvocationConditionTests {

    func test_mockDeferred_cancelShouldBeTakenIntoAccount() {

        let sink: SinkWithExpectation<Result<String, Error>> = makeSinkWithExpectation()
        let mock = MockTransformer()
        mock.whenAny().thenAfter(1, success: "1")

        let cancelToken = mock.transform(1, completion: sink.on)
        cancelToken.cancel()

        wait(for: sink, timeout: 3)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? CancelInvocationError)
        }
    }
}

// MARK: Mock In Order Tests

extension InvocationConditionTests {

    func test_mockInOrder_cancelShouldBeTakenIntoAccount() {

        let sink = CompletionSink<Result<String, Error>>()
        let mock = MockTransformer()
        let expectation = mock.whenAny().thenExpect()

        let cancelToken = mock.transform(1, completion: sink.on)
        cancelToken.cancel()
        expectation.success("1")

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? CancelInvocationError)
        }
    }
}
