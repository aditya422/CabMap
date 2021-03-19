import Foundation

protocol MapConfiguratorCovenant {
    func configure(mapController: MapViewController)
}

class MapConfigurator: MapConfiguratorCovenant {
    func configure(mapController: MapViewController) {
        let apiClient = APIClient(urlSessionConfiguration: URLSessionConfiguration.default,
                                  completionHandlerQueue: OperationQueue.main)
        let cabListSource = CabListSource(apiClient: apiClient)
        let cabListUsecas = GetCabListUsecase(cabListSource: cabListSource)
        let presenter = MapPresenter(view: mapController,
                                     getCabListUsecase: cabListUsecas)
        mapController.presenter = presenter
        presenter.view = mapController
    }
}
