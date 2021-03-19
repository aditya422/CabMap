import Foundation

typealias GetCabListUsecaseCompletion = (_ cabs: Result<[CabModel]>) -> Void

protocol GetCabListUsecaseCovenant {
    func getCabList(parameters: CabListRequestParameters, completion: @escaping GetCabListUsecaseCompletion)
}

class GetCabListUsecase: GetCabListUsecaseCovenant {
    let cabListSource: CabListSourceCovenant

    init(cabListSource: CabListSourceCovenant) {
        self.cabListSource = cabListSource
    }

    func getCabList(parameters: CabListRequestParameters, completion: @escaping GetCabListUsecaseCompletion) {
        cabListSource.cabList(parameters: parameters) { result in
            completion(result)
        }
    }
}
