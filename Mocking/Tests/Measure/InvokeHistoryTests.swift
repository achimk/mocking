import XCTest
@testable import Mocking

class InvokeHistoryTests: XCTest {

    func test_initialState_shouldBeEmpty() {
        let history = InvokeHistory<Int>()
        XCTAssertTrue(history.isEmpty)
    }

    func test_appendFirst_shouldNotBeEmpty() {
        let history = InvokeHistory<Int>()
        history.append(1)
        XCTAssertFalse(history.isEmpty)
    }

    func test_appendFirst_shouldContainOneItem() {
        let history = InvokeHistory<Int>()
        history.append(1)
        XCTAssertEqual(history.items, [1])
    }

    func test_multipleAppends_shouldContainCorrectOrder() {
        let history = InvokeHistory<Int>()
        history.append(1)
        history.append(2)
        history.append(3)
        XCTAssertEqual(history.items, [1, 2, 3])
    }

    func test_reset_shouldBeEmpty() {
        let history = InvokeHistory<Int>()
        history.append(1)
        history.append(2)
        history.append(3)
        XCTAssertTrue(history.isEmpty)
    }
}
