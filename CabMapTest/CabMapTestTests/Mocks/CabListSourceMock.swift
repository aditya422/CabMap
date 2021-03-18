@testable import CabMapTest

class CabListSourceMock: CabListSourceCovenant {
    var error: Error?
    
    func cabList(parameters: CabListRequestParameters, completion: @escaping GetCabListCompletion) {
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(getCabList()))
        }
    }
}

private extension CabListSourceMock {
    func getCabList() -> [CabModel] {
        [CabModel.sudoInstance(), CabModel.sudoInstance(), CabModel.sudoInstance()]
    }
}
