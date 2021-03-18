@testable import CabMapTest

class CabListViewMock: CabListView {
    var presenter: CabListPresenterCovenant!
    var state: CabListViewState?
    
    init() {}

    func viewStateChanged(state: CabListViewState) {
        self.state = state
    }
}
