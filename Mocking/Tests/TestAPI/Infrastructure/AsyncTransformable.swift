import Foundation

protocol AsyncCancelable {
    func cancel()
}

protocol AsyncTransformable {
    associatedtype Input
    associatedtype Output
    func transform(_ input: Input, completion: @escaping (Result<Output, Error>) -> Void) -> AsyncCancelable
}
