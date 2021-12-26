import XCTest
@testable import Mocking

//class RunTests: XCTestCase {
//
//    private let mock = MockAccountsFetchUseCase()
//    private var useCase: AccountsFetchHandling { mock }
//
//    func test_run() {
//        //mockWithExpectation()
//        mockWithConditions()
//        //mockWithMixed()
//
//        print("\n\n\n")
//        (0..<8).forEach {
//            fetch($0)
//        }
//        print("\n\n\n")
//    }
//
//    private func mockWithExpectation() {
//        let expectation = mock.whenAny().thenExpect()
//        expectation.success([])
//        expectation.success(["a"])
//        expectation.success(["a", "b"])
//        expectation.success(["a", "b", "c"])
//        expectation.failure(TestError())
//    }
//
//    private func mockWithConditions() {
//        mock.when { $0 == 1 }.then { ["a"] }
//        mock.when { $0 == 2 }.then { ["b"] }
//        mock.when { $0 == 3 }.then { ["c"] }
//        mock.when { $0 == 4 }.then { ["d"] }
//        mock.whenAny().then { throw TestError() }
//    }
//
//    private func mockWithMixed() {
//        mock.when { $0 == 1 }.then { ["a"] }
//        mock.when { $0 == 2 }.then { ["b"] }
//        mock.when { $0 == 7 }.then { ["c"] }
//        let expectation = mock.whenAny().thenExpect()
//        expectation.success(["a", "b"])
//        expectation.success(["a", "b", "c"])
//        expectation.failure(TestError())
//    }
//
//    private func fetch(_ page: Int) {
//        _ = useCase.fetchAccounts(page: page) { (result) in
//            print("-> page: \(page), result:", result)
//        }
//    }
//}
//
//// MARK: Utils
//
//protocol Cancelable {
//    func cancel()
//}
//
//class NopCancelable: Cancelable {
//
//    public init() { }
//
//    public func cancel() {
//        // no operation
//    }
//}
//
//extension InvocationCancelation: Cancelable { }
//
//// MARK: Domain / Presentation
//
//typealias Account = String
//
//protocol AccountsFetchHandling {
//    func fetchAccounts(page: Int, completion: @escaping Completion<[Account]>) -> Cancelable
//}
//
//class AccountsListPresenter {
//    private let fetchAccountsUseCase: AccountsFetchHandling
//
//    init(fetchAccountsUseCase: AccountsFetchHandling) {
//        self.fetchAccountsUseCase = fetchAccountsUseCase
//    }
//
//}
//
//// MARK: Testing
//
//class MockAccountsFetchUseCase: InvocationCondition<Int, [Account]>, AccountsFetchHandling {
//
//    func fetchAccounts(page: Int, completion: @escaping Completion<[Account]>) -> Cancelable {
//        handle(page, completion: completion)
//    }
//}
