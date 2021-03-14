import Foundation

protocol CabListConfiguratorCovenant {
    func configure(cabListController: CabListViewController)
}

class CabListConfigurator: CabListConfiguratorCovenant {
    func configure(cabListController: CabListViewController) {
        let apiClient = APIClient(urlSessionConfiguration: URLSessionConfiguration.default,
                                  completionHandlerQueue: OperationQueue.main)
        let cabListSource = CabListSource(apiClient: apiClient)
        let cabListUsecas = GetCabListUsecase(cabListSource: cabListSource)
        let presenter = CabListPresenter(view: cabListController,
                                         getCabListUsecase: cabListUsecas)
        cabListController.presenter = presenter
        presenter.view = cabListController
    }
}
