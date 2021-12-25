import Foundation

class InvokeDeferredStrategy<Output> {
    private let timeout: TimeInterval
    private var answerResult: Result<Output, Error>

    init(timeout: TimeInterval, answerResult: Result<Output, Error>) {
        self.timeout = timeout
        self.answerResult = answerResult
    }
}

extension InvokeDeferredStrategy: HandleCompletionStrategy {

    func handle(with completion: @escaping Completion<Output>) -> CancelToken {
        let token = OneTimeToken()

        DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [answerResult] in
            token.run {
                completion(answerResult)
            }
        }

        return CancelToken { error in
            token.run {
                completion(.failure(error))
            }
        }
    }
}
