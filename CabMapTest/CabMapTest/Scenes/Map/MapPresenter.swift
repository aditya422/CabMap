import Foundation
import CoreLocation

enum MapViewState {
    case clear
    case loading
    case showError(error: Error)
    case updateView(viewModel: MapViewModel)
}

protocol MapPresenterCovenant {
    func getCabsInTheRegion(firstPoint: CLLocationCoordinate2D, secondPoint: CLLocationCoordinate2D)
}

class MapPresenter: MapPresenterCovenant {
    var view: MapView?
    var getCabListUsecase: GetCabListUsecaseCovenant
    var cabList = [CabModel]()
    
    var viewState: MapViewState = .clear {
        didSet {
            view?.viewStateChanged(state: viewState)
        }
    }
    
    init(view: MapView?, getCabListUsecase: GetCabListUsecaseCovenant) {
        self.view = view
        self.getCabListUsecase = getCabListUsecase
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
                // TODO: - Remove following print after testing
                print("Success")
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
