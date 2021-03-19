@testable import CabMapTest
import Foundation

typealias URLSessionResponse = (data: Data?, response: URLResponse?, error: Error?)

class URLSessionMock: URLSessionCovenant {
    var responses = [URLSessionResponse]()
    
    func enqueue(response: URLSessionResponse) {
        responses.append(response)
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSessionDataTaskMock(response: responses.removeFirst(), completionHandler: completionHandler)
    }
}

class URLSessionDataTaskMock: URLSessionDataTask {
    let testResponse: URLSessionResponse
    let completionHandler: (Data?, URLResponse?, Error?) -> Void
    
    init(response: URLSessionResponse, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.testResponse = response
        self.completionHandler = completionHandler
    }
    
    override func resume() {
        completionHandler(testResponse.data, testResponse.response, testResponse.error)
    }
}

extension URL {
    static var testUrl: URL {
        return URL(string: "https://www.yahoo.com")!
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL.testUrl, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
    
}
