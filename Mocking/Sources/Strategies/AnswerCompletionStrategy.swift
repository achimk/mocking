import Foundation

protocol AnswerCompletionStrategy {
    associatedtype Answer
    func answer(with result: InvocationResult<Answer, Error>)
}
