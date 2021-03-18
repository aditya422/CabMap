import Foundation
import CoreLocation

enum MapViewState {
    case clear
    case loading
    case showError(error: Error)
    case updateView(viewModel: MapViewModel)
}

protocol MapPresenterCovenant {
    func viewDidLoad()
    func getCabsInTheRegion(firstPoint: CLLocationCoordinate2D, secondPoint: CLLocationCoordinate2D)
}

class MapPresenter: MapPresenterCovenant {
    var view: MapView?
    var getCabListUsecase: GetCabListUsecaseCovenant
    var cabList = [CabModel]()
    let constants = Constants()
    
    var viewState: MapViewState = .clear {
        didSet {
            view?.viewStateChanged(state: viewState)
        }
    }
    
    init(view: MapView?, getCabListUsecase: GetCabListUsecaseCovenant) {
        self.view = view
        self.getCabListUsecase = getCabListUsecase
    }
    
    func viewDidLoad() {
        // NOTE: - In this case the cab list is always empty
        viewState = .updateView(viewModel: MapViewModel(headerTitle: constants.headerTitle,
                                                        annotations: cabList.map { $0.mapToAnnotationModel() }))
    }
    
    func getCabsInTheRegion(firstPoint: CLLocationCoordinate2D, secondPoint: CLLocationCoordinate2D) {
        loadCabList(parameters: getCabListRequestPrameters(firstPoint: firstPoint,
                                                           secondPoint: secondPoint))
    }
}

private extension MapPresenter {
    func loadCabList(parameters: CabListRequestParameters) {
        viewState = .loading
        getCabListUsecase.getCabList(parameters: parameters) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case let .success(cabList):
                self.cabList = cabList
                self.viewState = .updateView(viewModel: MapViewModel(annotations: self.cabList.map { $0.mapToAnnotationModel() }))
            case let .failure(error):
                self.viewState = .showError(error: error)
            }
        }
    }
    
    func getCabListRequestPrameters(firstPoint: CLLocationCoordinate2D,
                                    secondPoint: CLLocationCoordinate2D) -> CabListRequestParameters {
        CabListRequestParameters(firstPointLattitude: firstPoint.latitude,
                                 firstPointLongitude: firstPoint.longitude,
                                 secondPointLatttitude: secondPoint.latitude,
                                 secondPointLongitude: secondPoint.longitude)
    }
}

extension MapPresenter {
    struct Constants {
        let headerTitle = "Map"
    }
}
