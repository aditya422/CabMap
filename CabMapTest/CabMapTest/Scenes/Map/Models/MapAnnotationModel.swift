import UIKit

struct MapAnnotationModel {
    let lattitude: Double
    let longitude: Double
    let image: UIImage
    let title: String
}

extension CabModel {
    func convertToAnnotationModel() -> MapAnnotationModel {
        MapAnnotationModel(lattitude: coordinate.latitude,
                           longitude: coordinate.longitude,
                           image: UIImage(named: "icon_map_taxi") ?? UIImage(),
                           title: type.rawValue)
    }
}
