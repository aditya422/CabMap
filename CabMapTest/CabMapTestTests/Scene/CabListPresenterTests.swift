@testable import CabMapTest
import XCTest

class CabListPresenterTests: XCTestCase {
    var cabListUsecaseMock = GetCabListUsecaseMock()
    var cabListRouterMock = CabListRouterMock()
    var mockView = CabListViewMock()
    var presenter: CabListPresenter!
    
    override func setUp() {
        presenter = CabListPresenter(view: mockView,
                                     getCabListUsecase: cabListUsecaseMock,
                                     router: cabListRouterMock)
    }
    
    func testViewLoaded() {
        // When
        presenter.viewDidLoad()
        
        // Then
        if case let .updateView(viewModel) = mockView.state {
            XCTAssertNotNil(viewModel.headerTitle)
        }
    }
    
    func testViewAppearedForFailure() {
        // Given
        let error = NSError(domain: NSURLErrorDomain, code: 400, userInfo: nil)
        cabListUsecaseMock.result = .failure(error)
        
        // When
        presenter.viewWillAppear()
        
        // Then
        guard case .showError = mockView.state else {
            XCTFail("Expecting network error")
            return
        }
    }
    
    func testViewAppearedForSuccess() {
        // Given
        cabListUsecaseMock.result = .success(getCabListForTest())
        
        // When
        presenter.viewWillAppear()
        
        // Then
        if case let .updateView(viewModel) = mockView.state {
            XCTAssertNil(viewModel.headerTitle)
        }
    }
    
    func testNumberOfRows() {
        // Given
        presenter.cabList = getCabListForTest()
        
        // When
        let numberOfRows = presenter.numberOfRows(in: 0)
        
        // Then
        XCTAssertEqual(numberOfRows,
                       presenter.cabList.count)
    }
    
    func testViewModelForIndexpath() {
        // Given
        presenter.cabList = getCabListForTest()
        let cellModel = getCabListForTest()[1].convertToCellModel()
        
        // When
        let presenterCellModel = presenter.viewModelFor(indexPath: IndexPath(row: 1, section: 0))
        
        // Then
        XCTAssertEqual(cellModel, presenterCellModel)
    }
    
    func testReloadList() {
        // Given
        cabListUsecaseMock.result = .success(getCabListForTest())
        
        // When
        presenter.reloadList()
        
        // Then
        if case let .updateView(viewModel) = mockView.state {
            XCTAssertNil(viewModel.headerTitle)
        }
    }
    
//    func testNavigateToMap() {
//        presenter.navigateToMapView()
//        
//    }
}

private extension CabListPresenterTests {
    func getCabListForTest() -> [CabModel] {
        [CabModel.sudoInstance(), CabModel.sudoInstance(), CabModel.sudoInstance()]
    }
}
