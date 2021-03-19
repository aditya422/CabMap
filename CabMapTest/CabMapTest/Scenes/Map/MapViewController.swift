import UIKit
import GoogleMaps

protocol MapView {
    var presenter: MapPresenterCovenant! {get set}

    func viewStateChanged(state: MapViewState)
}

class MapViewController: UIViewController {
    private var mapView: GMSMapView?
    internal var presenter: MapPresenterCovenant!
    private let constants = Constants()
    private let configurator = MapConfigurator()
    private let loader = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(mapController: self)
        presenter.viewDidLoad()
        addMapView()
    }
}

extension MapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        let bounds = GMSCoordinateBounds(region: mapView.projection.visibleRegion())
        let northEastBound = bounds.northEast
        let southWestBound = bounds.southWest
        presenter.getCabsInTheRegion(firstPoint: southWestBound,
                                     secondPoint: northEastBound)
    }
}

extension MapViewController: MapView {
    func viewStateChanged(state: MapViewState) {
        switch state {
        case let .updateView(viewModel):
            updateView(viewModel: viewModel)
        case .loading:
            showLoader()
        case let .showError(error):
            showErrorAlert(error: error)
        case .clear:
            break
        }
    }
}

private extension MapViewController {
    func addMapView() {
        let camera = GMSCameraPosition.camera(withLatitude: constants.hamburgLattitude,
                                              longitude: constants.hamburgLongitude,
                                              zoom: constants.mapDefaultZoomLevel)
        mapView = GMSMapView.map(withFrame: self.view.frame, camera: camera)
        guard let mapView = mapView else {
            return
        }
        mapView.delegate = self
        self.view.addSubview(mapView)
        setRegion()
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.map = mapView
    }
    
    func setRegion() {
        let northEast = CLLocationCoordinate2D(latitude: constants.northEastBoundLattitude,
                                               longitude: constants.northEastBoundLongitude)
        let southWest = CLLocationCoordinate2D(latitude: constants.southWestBoundLattitude,
                                               longitude: constants.southWestBoundLongitude)
        let bounds = GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)

        let update = GMSCameraUpdate.fit(bounds, withPadding: constants.boundPadding)
        mapView?.moveCamera(update)

    }
    
    func addAnnotationsOnMap(annotations: [MapAnnotationModel]) {
        guard let mapView = mapView else {
            return
        }
        mapView.clear()
        for annotation in annotations {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: annotation.lattitude,
                                                     longitude: annotation.longitude)
            marker.title = annotation.title
            marker.icon = annotation.image
            marker.map = mapView
        }
    }
    
    func showLoader() {
        loader.center = view.center
        view.addSubview(loader)
        loader.startAnimating()
    }

    func hideLoader() {
        loader.stopAnimating()
    }
    
    func showErrorAlert(error: Error) {
        hideLoader()
        let title: String
        let message: String
        
        if error is NetworkConnectionError {
            title = CommonConstants.errorAlertTitleForNoNetwork
            message = CommonConstants.errorAlertDescriptionForNoNetwork
        } else {
            title = CommonConstants.errorAlertTitle
            message = constants.errorAlertDescription
        }
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        let alertAction = UIAlertAction(title: CommonConstants.errorAlertOkActionTitle,
                                        style: .default)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true)
    }
    
    func updateView(viewModel: MapViewModel) {
        hideLoader()
        if let headerTitle = viewModel.headerTitle {
            title = headerTitle
        }
        if viewModel.annotations.count > 0 {
            addAnnotationsOnMap(annotations: viewModel.annotations)
        }
    }
}

// MARK: - Constants
private extension MapViewController {
    struct Constants {
        let hamburgLattitude = 53.5530854
        let hamburgLongitude = 9.757589
        let mapDefaultZoomLevel: Float = 12.0
        let northEastBoundLattitude = 53.694865
        let northEastBoundLongitude = 9.757589
        let southWestBoundLattitude = 53.394655
        let southWestBoundLongitude = 10.099891
        let boundPadding:CGFloat = 0.0
        let errorAlertDescription = "Please try again later"
    }
}
