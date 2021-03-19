struct CabModel: Equatable {
    struct Coordinate: Equatable {
        let latitude: Double
        let longitude: Double
    }

    let id: Int
    let coordinate: Coordinate
    let state: CabState
    let type: CabType
    let heading: Double
}
