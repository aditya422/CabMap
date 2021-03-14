protocol DomainConvertible {
    associatedtype DomainModel

    func convertToDomainModel() -> DomainModel
}

typealias Entity = Codable & DomainConvertible
