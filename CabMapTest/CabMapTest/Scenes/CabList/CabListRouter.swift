import UIKit

protocol CabListRouterCovenant {
    func navigateToMapView()
}

class CabListRouter: CabListRouterCovenant {
    var cabListController: CabListViewController?
    let constants = Constants()

    init(cabListController: CabListViewController) {
        self.cabListController = cabListController
    }

    func navigateToMapView() {
        let storyboard = UIStoryboard(name: constants.storyboardName, bundle: nil)
        let mapViewController = storyboard.instantiateViewController(identifier: constants.mapViewControllerIdentifier)
        cabListController?.present(mapViewController, animated: true, completion: nil)
    }
}

extension CabListRouter {
    struct Constants {
        let storyboardName = "Main"
        let mapViewControllerIdentifier = "MapViewController"
    }
}
