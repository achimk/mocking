import XCTest
import Mocking

// MARK: - Mocking

enum Event: Equatable {
    case start
    case cancel
    case pause
}

class MockEventRecorder: EventRecorder<Event>, DataProcessing {

    func start() {
        sink(.start)
    }

    func cancel() {
        sink(.cancel)
    }

    func pause() {
        sink(.pause)
    }
}

// MARK: - Tests

class EventRecorderTests: XCTestCase {

    // MARK: Verify

    func test_verifyCount_shouldBeCorrect() {

        let recorder = MockEventRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        XCTAssertTrue(recorder.verify(.start, count: 1))
        XCTAssertTrue(recorder.verify(.cancel, count: 2))
        XCTAssertTrue(recorder.verify(.pause, count: 0))
    }

    func test_verifyNever_shouldBeCorrect() {

        let recorder = MockEventRecorder()

        start(recorder)
        pause(recorder)

        XCTAssertFalse(recorder.verifyNever(.start))
        XCTAssertTrue(recorder.verifyNever(.cancel))
        XCTAssertFalse(recorder.verifyNever(.pause))
    }

    func test_verifyAny_shouldBeCorrect() {

        let recorder = MockEventRecorder()

        XCTAssertFalse(recorder.verifyAny())

        start(recorder)

        XCTAssertTrue(recorder.verifyAny())
    }

    func test_verifyAnyNever_shouldBeCorrect() {

        let recorder = MockEventRecorder()

        XCTAssertTrue(recorder.verifyAnyNever())

        start(recorder)

        XCTAssertFalse(recorder.verifyAnyNever())
    }

    func test_verifyContains_shouldBeCorrect() {

        let recorder = MockEventRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        XCTAssertTrue(recorder.verifyContains(.start))
        XCTAssertTrue(recorder.verifyContains(.cancel))
        XCTAssertFalse(recorder.verifyContains(.pause))
    }

    func test_verifyInOrderByLiteral_shouldBeCorrect() {

        let recorder = MockEventRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        XCTAssertFalse(recorder.verifyInOrder(.start, .cancel))

        XCTAssertTrue(recorder.verifyInOrder(.start, .cancel, .cancel))

        XCTAssertFalse(recorder.verifyInOrder(.start, .cancel, .pause))
    }

    func test_verifyInOrderByArray_shouldBeCorrect() {

        let recorder = MockEventRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        XCTAssertFalse(recorder.verifyInOrder([.start, .cancel]))

        XCTAssertTrue(recorder.verifyInOrder([.start, .cancel, .cancel]))

        XCTAssertFalse(recorder.verifyInOrder([.start, .cancel, .pause]))
    }


    // MARK: Other

    func test_reset_shouldResetMeasures() {

        let recorder = MockEventRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        recorder.reset()

        XCTAssertTrue(recorder.verify(.start, count: 0))
        XCTAssertTrue(recorder.verify(.cancel, count: 0))
        XCTAssertTrue(recorder.verify(.pause, count: 0))
        XCTAssertTrue(recorder.verifyNever(.start))
        XCTAssertTrue(recorder.verifyNever(.cancel))
        XCTAssertTrue(recorder.verifyNever(.pause))
        XCTAssertFalse(recorder.verifyAny())
        XCTAssertTrue(recorder.verifyAnyNever())
        XCTAssertFalse(recorder.verifyContains(.start))
        XCTAssertFalse(recorder.verifyContains(.cancel))
        XCTAssertFalse(recorder.verifyContains(.pause))
        XCTAssertTrue(recorder.verifyInOrder([]))
    }

    // MARK: Private

    private func start(_ process: DataProcessing) {
        process.start()
    }

    private func cancel(_ process: DataProcessing) {
        process.cancel()
    }

    private func pause(_ process: DataProcessing) {
        process.pause()
    }

}
