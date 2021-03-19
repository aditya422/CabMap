import UIKit

protocol CabListView {
    var presenter: CabListPresenterCovenant! {get set}

    func viewStateChanged(state: CabListViewState)
}

class CabListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var mapButton: UIBarButtonItem!
    
    // MARK: - Variables
    private let configurator = CabListConfigurator()
    // NOTE: - Presenter will never be nil and value for following var will definately be set from configurator.
    internal var presenter: CabListPresenterCovenant!
    private let constants = Constants()
    let loader = UIActivityIndicatorView(style: .large)

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(cabListController: self)
        presenter.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
    @IBAction func navigateToMapView(_ sender: UIBarButtonItem) {
        presenter.navigateToMapView()
    }
}

// MARK: - Tableview data source
extension CabListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfRows(in: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: constants.cellReuseIdentifier)
                as? CabListTableViewCell else {
            return UITableViewCell()
        }
        cell.setCellData(viewModel: presenter.viewModelFor(indexPath: indexPath))
        return cell
    }
}

// MARK: - View
extension CabListViewController: CabListView {
    func viewStateChanged(state: CabListViewState) {
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

private extension CabListViewController {
    func showLoader() {
        loader.center = view.center
        view.addSubview(loader)
        loader.startAnimating()
    }

    func hideLoader() {
        loader.stopAnimating()
    }

    func updateView(viewModel: CabListViewModel) {
        if let headerTitle = viewModel.headerTitle,
           let mapButtonTitle = viewModel.mapButtonTitle {
            self.title = headerTitle
            mapButton.title = mapButtonTitle
        }
        hideLoader()
        tableView.reloadData()
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
            message = CommonConstants.errorAlertDescription
        }
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        
        for action in getAlertActions(error: error) {
            alertController.addAction(action)
        }
        self.present(alertController, animated: true)
    }
    
    func getAlertActions(error: Error) -> [UIAlertAction] {
        let yesAlertAction = UIAlertAction(title: CommonConstants.errorAlertYesActionTitle,
                                           style: .default) {[weak self] action in
            if let self = self {
                self.presenter.reloadList()
            }
        }
        let noActionTitle = (error is NetworkConnectionError) ? CommonConstants.errorAlertOkActionTitle
            : CommonConstants.errorAlertNoActionTitle
        let NoAlertAction = UIAlertAction(title: noActionTitle,
                                          style: .cancel)
        if error is NetworkConnectionError {
            return [NoAlertAction]
        } else {
            return [yesAlertAction, NoAlertAction]
        }
        
    }
}

// MARK: - Constants
private extension CabListViewController {
    struct Constants {
        let cellReuseIdentifier = "Cell"

    }
}
