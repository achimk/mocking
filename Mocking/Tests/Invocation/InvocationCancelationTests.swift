import XCTest
@testable import Mocking

class InvocationCancelationTests: XCTestCase {

    func test_initialiseWithoutToken_shouldInvokeCorrectly() {
        let cancelation = InvocationCancelation()
        XCTAssertFalse(cancelation.isCanceled)

        cancelation.cancel()

        XCTAssertTrue(cancelation.isCanceled)
    }

    func test_initialiseWithToken_shouldInvokeCorretly() {
        var invoked = false
        var invokeCounter = 0
        let token = CancelToken { _ in
            invoked = true
            invokeCounter += 1
        }
        let cancelation = InvocationCancelation(token)
        XCTAssertFalse(cancelation.isCanceled)
        XCTAssertFalse(invoked)
        XCTAssertEqual(invokeCounter, 0)

        cancelation.cancel()

        XCTAssertTrue(cancelation.isCanceled)
        XCTAssertTrue(invoked)
        XCTAssertEqual(invokeCounter, 1)
    }

    func test_initialiseWithSealedToken_shouldNotInvoke() {
        var invoked = false
        var invokeCounter = 0
        let token = CancelToken { _ in
            invoked = true
            invokeCounter += 1
        }
        token.cancel(with: TestError())
        let cancelation = InvocationCancelation(token)
        XCTAssertTrue(cancelation.isCanceled)
        XCTAssertTrue(invoked)
        XCTAssertEqual(invokeCounter, 1)

        cancelation.cancel()

        XCTAssertTrue(cancelation.isCanceled)
        XCTAssertTrue(invoked)
        XCTAssertEqual(invokeCounter, 1)
    }

    func test_notifyHandlerOnCancel_shouldBeInvokedAfterCancelation() {
        var invoked = false
        let cancelation = InvocationCancelation()
        cancelation.onCancel {
            invoked = true
        }
        XCTAssertFalse(invoked)

        cancelation.cancel()

        XCTAssertTrue(invoked)
    }

    func test_notifyHandlerWhenCanceled_shouldBeInvokedImmediately() {
        var invoked = false
        let cancelation = InvocationCancelation()
        cancelation.cancel()
        cancelation.onCancel {
            invoked = true
        }
        XCTAssertTrue(invoked)
    }

    func test_notifyHandlerOnCancel_shouldNotifyOnlyOnce() {
        var invokeCounter = 0
        let cancelation = InvocationCancelation()
        cancelation.onCancel {
            invokeCounter += 1
        }

        XCTAssertEqual(invokeCounter, 0)

        cancelation.cancel()

        XCTAssertEqual(invokeCounter, 1)

        cancelation.cancel()

        XCTAssertEqual(invokeCounter, 1)
    }
}
