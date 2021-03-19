//

import UIKit

class CabListTableViewCell: UITableViewCell {
    // MARK: - Outlets
    @IBOutlet private weak var vehicleImageView: UIImageView!
    @IBOutlet private weak var vehicleTypeLabel: UILabel!
    @IBOutlet private weak var vehicleStatusView: UIView!
    @IBOutlet private weak var vehicleStatusLabel: UILabel!

    // MARK: - Variables
    private let constants = Constants()

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

// MARK: - Constants
private extension CabListTableViewCell {
    struct Constants {
        let stateViewCornerRadius: CGFloat = 5.0
    }
}

extension CabModel {
    func convertToCellModel() -> CabListTableViewCell.ViewModel {
        CabListTableViewCell.ViewModel(vehicleImage: getVehicleImage(),
                                       vehicleTitle: type.rawValue.capitalized,
                                       vehicleStateTitle: state.rawValue.capitalized,
                                       vehicleStateColor: getColorForState())
    }

    private func getVehicleImage() -> UIImage {
        switch type {
        case .taxi:
            return UIImage(named: "icon_taxi") ?? UIImage()
        }
    }

    private func getColorForState() -> UIColor {
        switch state {
        case .active:
            return CommonConstants.activeGreenColor
        case .inactive:
            return CommonConstants.inactiveRedColor

        }
    }
}
