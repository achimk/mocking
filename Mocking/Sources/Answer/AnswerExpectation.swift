import Foundation

class AnswerExpectation<Output> {
    private let consumeAnswer: (Result<Output, Error>) -> Void

    init(consumeAnswer: @escaping (Result<Output, Error>) -> Void) {
        self.consumeAnswer = consumeAnswer
    }

    func success(_ value: Output) {
        consumeAnswer(.success(value))
    }

    func failure(_ error: Error) {
        consumeAnswer(.failure(error))
    }
}
