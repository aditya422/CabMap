// NOTE: - This function will be used for unit tests
extension CabModel {
    static func sudoInstance() -> CabModel {
        CabModel(id: 478676757,
                 coordinate: CabModel.Coordinate(latitude: 53.56259930553767,
                                                 longitude: 9.969699753347925),
                 state: .active,
                 type: .taxi,
                 heading: 224.76276961020116)
    }
}
