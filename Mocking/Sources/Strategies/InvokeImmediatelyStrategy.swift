import Foundation

class InvokeImmediatelyStrategy<Output> {
    let answerResult: Result<Output, Error>

    init(_ result: Result<Output, Error>) {
        answerResult = result
    }
}

extension InvokeImmediatelyStrategy: HandleCompletionStrategy {

    func handle(with completion: @escaping Completion<Output>) -> CancelToken {
        completion(answerResult)
        return CancelToken()
    }
}
