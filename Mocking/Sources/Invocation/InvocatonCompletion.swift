import Foundation

class InvocationCompletion<T> {
    private let token = OneTimeToken()
    private let completion: Completion<T>

    init(completion: @escaping Completion<T>) {
        self.completion = completion
    }

    func complete(with result: Result<T, Error>) {
        token.run { [completion] in
            completion(result)
        }
    }
}

