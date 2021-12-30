import XCTest
@testable import Mocking

class InvokeCounterTests: XCTestCase {

    func test_initialState_shouldBeZero() {
        let counter = InvokeCounter()
        XCTAssertEqual(counter.count, 0)
    }

    func test_increment_shouldIncrementByOne() {
        let counter = InvokeCounter()
        counter.increment()
        XCTAssertEqual(counter.count, 1)
    }

    func test_multipleIncrement_shouldIncrementByOne() {
        let counter = InvokeCounter()
        counter.increment()
        counter.increment()
        counter.increment()
        XCTAssertEqual(counter.count, 3)
    }

    func test_reset_shouldResetState() {
        let counter = InvokeCounter()
        counter.increment()
        counter.increment()
        counter.increment()
        counter.reset()
        XCTAssertEqual(counter.count, 0)
    }
}
