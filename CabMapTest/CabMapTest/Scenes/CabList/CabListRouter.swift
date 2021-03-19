import UIKit

protocol CabListRouterCovenant {
    func navigateToMapView()
}

class CabListRouter: CabListRouterCovenant {
    internal var cabListController: CabListViewController?
    private let constants = Constants()

    init(cabListController: CabListViewController) {
        self.cabListController = cabListController
    }

    func navigateToMapView() {
        let storyboard = UIStoryboard(name: constants.storyboardName, bundle: nil)
        let mapViewController = storyboard.instantiateViewController(identifier: constants.mapViewControllerIdentifier)
        cabListController?.navigationController?.pushViewController(mapViewController, animated: true)
    }
}

// MARK: - Constants
private extension CabListRouter {
    struct Constants {
        let storyboardName = "Main"
        let mapViewControllerIdentifier = "MapViewController"
    }
}
