struct CabListResponseEntity: Codable {
    struct CabEntity: Entity {
        struct Coordinate: Codable {
            let latitude: Double?
            let longitude: Double?
        }

        let id: Int?
        let state: String?
        let type: String?
        let heading: Double?
        let coordinate: Coordinate?

        func convertToDomainModel() -> CabModel {
            return CabModel(id: id ?? 0,
                            coordinate: CabModel.Coordinate(latitude: coordinate?.latitude ?? 0.0,
                                                            longitude: coordinate?.longitude ?? 0.0),
                            state: CabState(rawValue: state ?? "") ?? .active,
                            type: CabType(rawValue: type ?? "") ?? .taxi,
                            heading: heading ?? 0.0)
        }
    }

    let poiList: [CabEntity]
}


