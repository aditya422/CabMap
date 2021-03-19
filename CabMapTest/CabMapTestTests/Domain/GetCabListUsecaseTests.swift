@testable import CabMapTest
import XCTest

class GetCabListUsecaseTests: XCTestCase {

    var sourceMock = CabListSourceMock()
    var cabListUseCase: GetCabListUsecase!
    
    override func setUp() {
        super.setUp()
        cabListUseCase = GetCabListUsecase(cabListSource: sourceMock)
    }
    
    func testGetCabListForSuccess() {
        // Given
        let succes = expectation(description: "Success")
        sourceMock.error = nil
        
        // When
        cabListUseCase.getCabList(parameters: getParameters()) { result in
            if case .success = result {
                // Then
                succes.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testGetCabListForFailure() {
        // Given
        let failure = expectation(description: "Failure")
        sourceMock.error = NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)
        
        // When
        cabListUseCase.getCabList(parameters: getParameters()) { result in
            if case .failure = result {
                // Then
                failure.fulfill()
            }
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

}

private extension GetCabListUsecaseTests {
    func getParameters() -> CabListRequestParameters {
        CabListRequestParameters(firstPointLattitude: 10.21, firstPointLongitude: 10.21,
                                 secondPointLatttitude: 10.21, secondPointLongitude: 10.21)
    }
}
