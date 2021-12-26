import Foundation
import Mocking

extension InvocationCancelation: AsyncCancelable { }

final class MockTransformer: MockResource<Int, String>, AsyncTransformable {

    @discardableResult
    func transform(_ input: Int, completion: @escaping (Result<String, Error>) -> Void) -> AsyncCancelable {
        return handle(input, completion: completion)
    }
}
