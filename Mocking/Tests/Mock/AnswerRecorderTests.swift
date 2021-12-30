import XCTest
import Mocking

class AnswerRecorderTests: XCTestCase {

    typealias MockTransformer = AnswerRecorder<Int, String>
    private var sink = CompletionSink<Result<String, Error>>()

    override func setUp() {
        super.setUp()
        sink = CompletionSink<Result<String, Error>>()
    }

    // MARK: Test Handle

    func test_registeredHandler_shouldMockResponse() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        mock.handle(1, completion: sink.on)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isSuccess)
            XCTAssertEqual($0.value, "1")
        }
    }

    func test_unregisteredHandler_shouldReturnCorrectError() {
        let mock = MockTransformer()

        mock.handle(1, completion: sink.on)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? UnhandledInvocationError)
        }
    }

    func test_unspecifiedCancelError_shouldReturnDefaultError() {
        let mock = MockTransformer()
        _ = mock.whenAny().thenExpect()

        let token = mock.handle(1, completion: sink.on)
        token.cancel()

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? CancelInvocationError)
        }
    }

    func test_specifiedCancelError_shouldReturnCorrectError() {
        let mock = MockTransformer()
        _ = mock.whenAny().thenExpect()

        let token = mock.handle(1, completion: sink.on)
        token.error = CancelError()
        token.cancel()

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? CancelError)
        }
    }

    // MARK: Test Register

    func test_registerSpecificCondition_shouldHandleCorrectly() {
        let mock = MockTransformer()
        mock.when { $0.count == 1 }.thenSuccess("1")

        mock.handle(1, completion: sink.on)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isSuccess)
            XCTAssertEqual($0.value, "1")
        }

        mock.handle(2, completion: sink.on)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? UnhandledInvocationError)
        }

        XCTAssertEqual(sink.invokeCount, 2)
    }

    func test_registerAnyCondition_shouldHandleCorrectly() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        mock.handle(1, completion: sink.on)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isSuccess)
            XCTAssertEqual($0.value, "1")
        }

        mock.handle(2, completion: sink.on)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isSuccess)
            XCTAssertEqual($0.value, "1")
        }

        XCTAssertEqual(sink.invokeCount, 2)
    }

    // MARK: Test Verify

    func test_verifyInvokeCount_shouldBeCorect() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        XCTAssertTrue(mock.verify(count: 0))

        mock.handle(1, completion: sink.on)
        mock.handle(2, completion: sink.on)
        mock.handle(3, completion: sink.on)

        XCTAssertTrue(mock.verify(count: 3))
    }

    func test_verifyInvokeNever_shouldBeCorrect() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        XCTAssertTrue(mock.verifyNever())

        mock.handle(1, completion: sink.on)

        XCTAssertFalse(mock.verifyNever())
    }

    func test_verifyInOrderByLiteral_shouldBeCorrect() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        mock.handle(1, completion: sink.on)
        mock.handle(2, completion: sink.on)
        mock.handle(3, completion: sink.on)

        XCTAssertTrue(mock.verifyInOrder(1, 2, 3))
    }

    func test_verifyInOrderByList_shouldBeCorrect() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        mock.handle(1, completion: sink.on)
        mock.handle(2, completion: sink.on)
        mock.handle(3, completion: sink.on)

        XCTAssertTrue(mock.verifyInOrder([1, 2, 3]))
    }

    func test_verifyContains_shouldBeCorrect() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        XCTAssertFalse(mock.verifyContains(1))

        mock.handle(1, completion: sink.on)

        XCTAssertTrue(mock.verifyContains(1))
    }

    // MARK: Test Others

    func test_resetMock_shouldResetAllMeasures() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        mock.handle(1, completion: sink.on)

        XCTAssertTrue(mock.verify(count: 1))
        XCTAssertFalse(mock.verifyNever())
        XCTAssertTrue(mock.verifyContains(1))
        XCTAssertTrue(mock.verifyInOrder([1]))

        mock.reset()

        XCTAssertTrue(mock.verify(count: 0))
        XCTAssertTrue(mock.verifyNever())
        XCTAssertFalse(mock.verifyContains(1))
        XCTAssertTrue(mock.verifyInOrder([]))
    }

    func test_clearConditions_shouldUnregisterAllConditions() {
        let mock = MockTransformer()
        mock.whenAny().thenSuccess("1")

        mock.handle(1, completion: sink.on)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isSuccess)
            XCTAssertEqual($0.value, "1")
        }

        mock.clearConditions()
        mock.handle(2, completion: sink.on)

        assertPresent(sink.lastResult) {
            XCTAssertTrue($0.isFailure)
            XCTAssertNotNil($0.error as? UnhandledInvocationError)
        }

    }
}
