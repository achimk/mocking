import Foundation

protocol AnswerCompletionStrategy {
    associatedtype Output
    func answer(with result: Result<Output, Error>)
}
