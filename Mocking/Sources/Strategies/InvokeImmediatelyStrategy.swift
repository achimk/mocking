import Foundation

class InvokeImediatelyStrategy<Output> {
    private var answerResult: Result<Output, Error>

    init(_ result: Result<Output, Error>) {
        answerResult = result
    }
}

extension InvokeImediatelyStrategy {

    func handle(with completion: @escaping Completion<Output>) -> CancelToken {
        completion(answerResult)
        return CancelToken()
    }
}
