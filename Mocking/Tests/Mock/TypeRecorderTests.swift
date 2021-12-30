import XCTest
import Mocking

// MARK: - Mocking

struct StartEvent { }
struct CancelEvent { }
struct PauseEvent { }

class MockTypeRecorder: TypeRecorder, DataProcessing {

    func start() {
        sink(StartEvent.self)
    }

    func cancel() {
        sink(CancelEvent.self)
    }

    func pause() {
        sink(PauseEvent.self)
    }
}

// MARK: - Tests

class TypeRecorderTests: XCTestCase {

    // MARK: Verify

    func test_verifyCount_shouldBeCorrect() {

        let recorder = MockTypeRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        XCTAssertTrue(recorder.verify(StartEvent.self, count: 1))
        XCTAssertTrue(recorder.verify(CancelEvent.self, count: 2))
        XCTAssertTrue(recorder.verify(PauseEvent.self, count: 0))
    }

    func test_verifyNever_shouldBeCorrect() {

        let recorder = MockTypeRecorder()

        start(recorder)
        pause(recorder)

        XCTAssertFalse(recorder.verifyNever(StartEvent.self))
        XCTAssertTrue(recorder.verifyNever(CancelEvent.self))
        XCTAssertFalse(recorder.verifyNever(PauseEvent.self))
    }

    func test_verifyAny_shouldBeCorrect() {

        let recorder = MockTypeRecorder()

        XCTAssertFalse(recorder.verifyAny())

        start(recorder)

        XCTAssertTrue(recorder.verifyAny())
    }

    func test_verifyAnyNever_shouldBeCorrect() {

        let recorder = MockTypeRecorder()

        XCTAssertTrue(recorder.verifyAnyNever())

        start(recorder)

        XCTAssertFalse(recorder.verifyAnyNever())
    }

    func test_verifyContains_shouldBeCorrect() {

        let recorder = MockTypeRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        XCTAssertTrue(recorder.verifyContains(StartEvent.self))
        XCTAssertTrue(recorder.verifyContains(CancelEvent.self))
        XCTAssertFalse(recorder.verifyContains(PauseEvent.self))
    }

    func test_verifyInOrderByLiteral_shouldBeCorrect() {

        let recorder = MockTypeRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        XCTAssertFalse(recorder.verifyInOrder(StartEvent.self, CancelEvent.self))

        XCTAssertTrue(recorder.verifyInOrder(StartEvent.self, CancelEvent.self, CancelEvent.self))

        XCTAssertFalse(recorder.verifyInOrder(StartEvent.self, CancelEvent.self, PauseEvent.self))
    }

    func test_verifyInOrderByArray_shouldBeCorrect() {

        let recorder = MockTypeRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        XCTAssertFalse(recorder.verifyInOrder([StartEvent.self, CancelEvent.self]))

        XCTAssertTrue(recorder.verifyInOrder([StartEvent.self, CancelEvent.self, CancelEvent.self]))

        XCTAssertFalse(recorder.verifyInOrder([StartEvent.self, CancelEvent.self, PauseEvent.self]))
    }

    // MARK: Other

    func test_reset_shouldResetMeasures() {

        let recorder = MockTypeRecorder()

        start(recorder)
        cancel(recorder)
        cancel(recorder)

        recorder.reset()

        XCTAssertTrue(recorder.verify(StartEvent.self, count: 0))
        XCTAssertTrue(recorder.verify(CancelEvent.self, count: 0))
        XCTAssertTrue(recorder.verify(PauseEvent.self, count: 0))
        XCTAssertTrue(recorder.verifyNever(StartEvent.self))
        XCTAssertTrue(recorder.verifyNever(CancelEvent.self))
        XCTAssertTrue(recorder.verifyNever(PauseEvent.self))
        XCTAssertFalse(recorder.verifyAny())
        XCTAssertTrue(recorder.verifyAnyNever())
        XCTAssertFalse(recorder.verifyContains(StartEvent.self))
        XCTAssertFalse(recorder.verifyContains(CancelEvent.self))
        XCTAssertFalse(recorder.verifyContains(PauseEvent.self))
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
