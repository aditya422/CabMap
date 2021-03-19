//

import Foundation

struct CabAPIRequest: APIRequestCovenant {
    let firstPointLattitude: Double
    let firstPointLongitude: Double
    let secondPointLatttitude: Double
    let secondPointLongitude: Double

    var urlRequest: URLRequest {
        let url: URL! = URL(string: "https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=\(secondPointLatttitude)&p1Lon=\(firstPointLongitude)&p1Lat=\(firstPointLattitude)&p2Lon=\(secondPointLongitude)")
        var request = URLRequest(url: url)

        request.setValue("application/json", forHTTPHeaderField: "Accept")

        request.httpMethod = RequestType.GET.rawValue

        return request
    }
}
