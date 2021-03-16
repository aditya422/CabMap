import UIKit

protocol CabListView {
    var presenter: CabListPresenterCovenant! {get set}

    func viewStateChanged(state: CabListViewState)
}

class CabListViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    // MARK: - Variables
    let configurator = CabListConfigurator()
    // NOTE: - Presenter will never be nil and value for following var will definately be set from configurator.
    var presenter: CabListPresenterCovenant!
    let constants = Constants()
    let loader = UIActivityIndicatorView(style: .large)

    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        default:
            break
        }
    }
}

extension CabListViewController {
    struct Constants {
        let cellReuseIdentifier = "Cell"
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
}
