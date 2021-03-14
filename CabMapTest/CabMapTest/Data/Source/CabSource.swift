import Foundation

typealias GetCabListCompletion = (_ result: Result<[CabModel]>) -> Void

protocol CabSourceCovenant {
    func cabList(parameters: CabListRequestParameters, completion: @escaping GetCabListCompletion)
}

class CabListSource: CabSourceCovenant {
    let apiClient: APIClient

    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }

    func cabList(parameters: CabListRequestParameters, completion: @escaping GetCabListCompletion) {
        let getCabListRequest = CabAPIRequest(firstPointLattitude: parameters.firstPointLattitude,
                                              firstPointLongitude: parameters.firstPointLongitude,
                                              secondPointLatttitude: parameters.secondPointLatttitude,
                                              secondPointLongitude: parameters.secondPointLongitude)
        apiClient.execute(request: getCabListRequest) { (result: Result<APIResponse<CabListResponseEntity>>) in
            switch result {
            case let .success(response):
//                let listResponse = response.ke
                let cabs = response.entity.poiList.map { return $0.convertToDomainModel() }
                completion(.success(cabs))
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}
