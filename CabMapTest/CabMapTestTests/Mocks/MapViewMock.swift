@testable import CabMapTest

class MapViewMock: MapView {
    var presenter: MapPresenterCovenant!
    var state: MapViewState?
    
    init () {}

    func viewStateChanged(state: MapViewState) {
        self.state = state
    }
}
