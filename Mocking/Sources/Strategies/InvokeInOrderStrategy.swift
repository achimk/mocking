import Foundation

class InvokeInOrderStrategy<Output>: HandleCompletionStrategy, AnswerCompletionStrategy {
    private var answers: [InvocationResult<Output, Error>] = []
    private var completions: [InvocationCompletion<Output>] = []

    func answer(with result: InvocationResult<Output, Error>) {
        answers.append(result)
        startDequeue()
    }

    func handle(with completion: @escaping InvocationCompletion<Output>) {
        completions.append(completion)
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
