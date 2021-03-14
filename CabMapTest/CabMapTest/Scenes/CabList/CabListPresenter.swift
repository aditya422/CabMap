import Foundation

enum CabListViewState {
    case clear
    case loading
    case showError(error: Error)
    case updateView(viewModel: CabListViewModel)
}

protocol CabListPresenterCovenant {
    var view: CabListView? { get set }
    func viewDidLoad()
}

class CabListPresenter: CabListPresenterCovenant {
    var view: CabListView?
    var getCabListUsecase: GetCabListUsecaseCovenant

    init(view: CabListView, getCabListUsecase: GetCabListUsecaseCovenant) {
        self.view = view
        self.getCabListUsecase = getCabListUsecase
    }

    func viewDidLoad() {
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
            getCabListUsecase.getCabList(parameters: getCabListRequestPrameters()) { result in
                switch result {
                case let .success(cabList):
                    print("Success = \(cabList)")
                case let .failure(error):
                    print("error = \(error)")
                }
            }
    }
}
