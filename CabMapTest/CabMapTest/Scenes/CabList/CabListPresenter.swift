import Foundation

enum CabListViewState {
    case clear
    case loading
    case showError(error: Error)
    case updateView(viewModel: CabListViewModel)
}

protocol CabListPresenterCovenant {
    var view: CabListView? { get set }
    var router: CabListRouterCovenant? { get set }
    func viewDidLoad()
    func viewWillAppear()
    func numberOfRows(in section: Int) -> Int
    func viewModelFor(indexPath: IndexPath) -> CabListTableViewCell.ViewModel
    func navigateToMapView()
    func reloadList()
}

class CabListPresenter: CabListPresenterCovenant {
    var view: CabListView?
    var router: CabListRouterCovenant?
    var getCabListUsecase: GetCabListUsecaseCovenant
    var cabList = [CabModel]()
    let constants = Constants()

    var viewState: CabListViewState = .clear {
        didSet {
            view?.viewStateChanged(state: viewState)
        }
    }

    init(view: CabListView, getCabListUsecase: GetCabListUsecaseCovenant,
         router: CabListRouterCovenant) {
        self.view = view
        self.getCabListUsecase = getCabListUsecase
        self.router = router
    }

    func viewDidLoad() {
        viewState = .updateView(viewModel: getViewModel())
    }

    func viewWillAppear() {
        loadCabList()
    }

    func numberOfRows(in section: Int) -> Int {
        cabList.count
    }

    func viewModelFor(indexPath: IndexPath) -> CabListTableViewCell.ViewModel {
        cabList[indexPath.row].mapToCellModel()
    }

    func navigateToMapView() {
        router?.navigateToMapView()
    }
    
    func reloadList() {
        loadCabList()
    }
}

private extension CabListPresenter {
    func getCabListRequestPrameters() -> CabListRequestParameters {
        CabListRequestParameters(firstPointLattitude: 53.694865,
                                 firstPointLongitude: 9.757589,
                                 secondPointLatttitude: 53.394655,
                                 secondPointLongitude: 10.099891)
    }

    func loadCabList() {
        viewState = .loading
        getCabListUsecase.getCabList(parameters: getCabListRequestPrameters()) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(cabList):
                self.cabList = cabList
                self.viewState = .updateView(viewModel: CabListViewModel())
            case let .failure(error):
                self.viewState = .showError(error: error)
            }
        }
    }

    func getViewModel() -> CabListViewModel {
        CabListViewModel(headerTitle: constants.cabListHeaderTile,
                         mapButtonTitle: constants.cabListMapButonTitle)
    }
}

extension CabListPresenter {
    struct Constants {
        let cabListHeaderTile = "Cab List"
        let cabListMapButonTitle = "Map"
    }
}
