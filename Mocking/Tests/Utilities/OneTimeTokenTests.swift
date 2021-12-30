import XCTest
@testable import Mocking

class OneTimeTokenTests: XCTestCase {

    func test_initialiseToken_shouldNotBeSealed() {
        let token = OneTimeToken()
        XCTAssertFalse(token.isSealed)
    }

    func test_runToken_shouldBeSealed() {
        let token = OneTimeToken()
        token.run { }
        XCTAssertTrue(token.isSealed)
    }

    func test_runMultipleTimes_shouldBeInvokedOnlyOnce() {
        var invokeCounter = 0
        let block: () -> Void = {
            invokeCounter += 1
        }

        let token = OneTimeToken()
        token.run(block)
        token.run(block)
        token.run(block)

        XCTAssertEqual(invokeCounter, 1)
    }
}
