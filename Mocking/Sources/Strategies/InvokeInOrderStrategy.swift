import Foundation

class InvokeInOrderStrategy<Output> {
    private(set) var answers: [Result<Output, Error>] = []
    private(set) var completions: [Completion<Output>] = []
}

extension InvokeInOrderStrategy: HandleCompletionStrategy {

    func handle(with completion: @escaping Completion<Output>) -> CancelToken {
        completions.append(completion)
        startDequeue()
        return CancelToken { [weak self] (error) in
            self?.cancel(with: error)
        }
    }
}

extension InvokeInOrderStrategy: AnswerCompletionStrategy {

    func answer(with result: Result<Output, Error>) {
        answers.append(result)
        startDequeue()
    }
}

extension InvokeInOrderStrategy {

    private func cancel(with error: Error) {
        guard answers.isEmpty && !completions.isEmpty else {
            return
        }

        answers.append(.failure(error))
        startDequeue()
    }

    private func canDequeue() -> Bool {
        return !answers.isEmpty && !completions.isEmpty
    }

    private func startDequeue() {
        if canDequeue() {
            dequeueAndRunFirst()
            startDequeue()
        }
    }

    private func dequeueAndRunFirst() {
        guard
            let answer = answers.first,
            let completion = completions.first
        else {
            return
        }

        completion(answer)

        answers.removeFirst()
        completions.removeFirst()
    }
}

