//

import UIKit

class CabListTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet weak var vehicleImageView: UIImageView!
    @IBOutlet weak var vehicleTypeLabel: UILabel!
    @IBOutlet weak var vehicleStatusView: UIView!
    @IBOutlet weak var vehicleStatusLabel: UILabel!

    // MARK: - Variables
    let constants = Constants()

    // MARK: - Functions
    override func awakeFromNib() {
        super.awakeFromNib()
        vehicleStatusView.layer.cornerRadius = constants.stateViewCornerRadius
        vehicleStatusLabel.clipsToBounds = true
    }

    func setCellData(viewModel: ViewModel) {
        vehicleImageView.image = viewModel.vehicleImage
        vehicleTypeLabel.text = viewModel.vehicleTitle
        vehicleStatusView.backgroundColor = viewModel.vehicleStateColor
        vehicleStatusLabel.textColor = viewModel.vehicleStateColor
        vehicleStatusLabel.text = viewModel.vehicleStateTitle
    }

}

extension CabListTableViewCell {
    struct ViewModel: Equatable {
        let vehicleImage: UIImage
        let vehicleTitle: String
        let vehicleStateTitle: String
        let vehicleStateColor: UIColor
    }
}

extension CabListTableViewCell {
    struct Constants {
        let stateViewCornerRadius: CGFloat = 5.0
    }
}

extension CabModel {
    func mapToCellModel() -> CabListTableViewCell.ViewModel {
        CabListTableViewCell.ViewModel(vehicleImage: getVehicleImage(),
                                       vehicleTitle: type.rawValue.capitalized,
                                       vehicleStateTitle: state.rawValue.capitalized,
                                       vehicleStateColor: getColorForState())
    }

    private func getVehicleImage() -> UIImage {
        switch type {
        case .taxi:
            return UIImage(named: "icon_taxi") ?? UIImage()
        case .moped:
            return UIImage(named: "icon_moped") ?? UIImage()
        }
    }

    private func getColorForState() -> UIColor {
        switch state {
        case .active:
            return UIColor(red: 161/255.0, green: 250/255.0, blue: 78/255.0, alpha: 1.0)
        case .inactive:
            return UIColor(red: 226/255.0, green: 62/255.0, blue: 42/255.0, alpha: 1.0)

        }
    }
}
