import Foundation

class InvokeInOrderStrategy<Output>: HandleCompletionStrategy, AnswerCompletionStrategy, CancelCompletionStrategy {
    private var answers: [Result<Output, Error>] = []
    private var completions: [Completion<Output>] = []

    func answer(with result: Result<Output, Error>) {
        answers.append(result)
        startDequeue()
    }

    func handle(with completion: @escaping Completion<Output>) {
        completions.append(completion)
        startDequeue()
    }

    func cancel(with error: Error) {
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
