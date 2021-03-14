//

import UIKit

protocol CabListView {
    var presenter: CabListPresenterCovenant! {get set}

    func viewStateChanged(state: CabListViewState)
}

class CabListViewController: UIViewController {
    let configurator = CabListConfigurator()
    // NOTE: - Presenter will never be nil and value for following var will definately be set from configurator.
    var presenter: CabListPresenterCovenant!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configurator.configure(cabListController: self)
        presenter.viewDidLoad()
    }


}

extension CabListViewController: CabListView {
    func viewStateChanged(state: CabListViewState) {

    }


}

