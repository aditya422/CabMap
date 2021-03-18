@testable import CabMapTest

class GetCabListUsecaseMock: GetCabListUsecaseCovenant {
    var result: Result<[CabModel]>?
    
    func getCabList(parameters: CabListRequestParameters, completion: @escaping GetCabListUsecaseCompletion) {
        guard let result = result else {
            return
        }
        completion(result)
    }
    
    
}
