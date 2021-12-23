import Foundation

typealias InvocationCompletion<T> = (InvocationResult<T, Error>) -> Void

typealias InvocationResult<Success, Failure: Error> = Result<Success, Failure>

//enum InvocationResult<Success, Failure> {
//    case success(Success)
//    case failure(Failure)
//    case cancel
//
//    init(catching: () throws -> Success) where Failure == Error {
//        do {
//            let value = try catching()
//            self = .success(value)
//        } catch {
//            self = .failure(error)
//        }
//    }
//}
