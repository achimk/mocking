import Foundation

public class AnswerExpectation<Output> {
    private let consumeAnswer: (Result<Output, Error>) -> Void

    init(consumeAnswer: @escaping (Result<Output, Error>) -> Void) {
        self.consumeAnswer = consumeAnswer
    }

    public func success(_ value: Output) {
        consumeAnswer(.success(value))
    }

    public func failure(_ error: Error) {
        consumeAnswer(.failure(error))
    }
}
