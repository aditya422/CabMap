@testable import CabMapTest
import CoreLocation
import XCTest

class MapPresenterTests: XCTestCase {
    var cabListUsecaseMock = GetCabListUsecaseMock()
    var mockView = MapViewMock()
    var presenter: MapPresenter!
    
    override func setUp() {
        super.setUp()
        presenter = MapPresenter(view: mockView, getCabListUsecase: cabListUsecaseMock)
    }
    
    func testViewLoaded() {
        // When
        presenter.viewDidLoad()
        
        // Then
        if case let .updateView(viewModel) = mockView.state {
            XCTAssertNotNil(viewModel.headerTitle)
            XCTAssertEqual(viewModel.annotations.count, 0)
        }
    }
    
    func testGetCabsInRegionForSuccess() {
        // Given
        cabListUsecaseMock.result = .success(getCabListForTest())
        
        // When
        presenter.getCabsInTheRegion(firstPoint: CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589),
                                     secondPoint: CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891))
        
        // Then
        if case let .updateView(viewModel) = mockView.state {
            XCTAssertNil(viewModel.headerTitle)
            XCTAssertEqual(viewModel.annotations.count, 3)
        }
    }
    
    func testCabsInRegionForFailure() {
        // Given
        let error = NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)
        cabListUsecaseMock.result = .failure(error)
        
        // When
        presenter.getCabsInTheRegion(firstPoint: CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589),
                                     secondPoint: CLLocationCoordinate2D(latitude: 53.394655, longitude: 10.099891))
        
        // Then
        guard case .showError = mockView.state else {
            XCTFail("Expecting network error")
            return
        }
    }
}

private extension MapPresenterTests {
    func getCabListForTest() -> [CabModel]{
        [CabModel.sudoInstance(), CabModel.sudoInstance(), CabModel.sudoInstance()]
    }
}
