@testable import CabMapTest
import XCTest

class APIRequestTests: XCTestCase {
    let urlSessionMock = URLSessionMock()
    
    var apiClient: APIClient!
    
    override func setUp() {
        super.setUp()
        apiClient = APIClient(urlSession: urlSessionMock)
    }
    
    func testResponseAndParsingSucccess() {
        // Give
        let expectedResponse = "{\"key\":\"value\"}"
        let expectedData = expectedResponse.data(using: .utf8)
        let expectedSuccessResponse = HTTPURLResponse(statusCode: 200)
        
        urlSessionMock.enqueue(response: (data: expectedData, response: expectedSuccessResponse, error: nil))
        
        let completionExpectation = expectation(description: "Success completion")
        
        // When
        apiClient.execute(request: RequestMock()) { (result: Result<APIResponse<EntityMock>>) in
            // Then
            guard let response = try? result.get() else {
                XCTFail("Expected successful response")
                return
            }
            
            XCTAssertEqual(expectedResponse, response.entity.utf8String)
            completionExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testResponseSuccessAndParsingFailure() {
        // Give
        let expectedResponse = "{\"key\":\"value\"}"
        let expectedData = expectedResponse.data(using: .utf8)
        let expectedSuccessResponse = HTTPURLResponse(statusCode: 200)
        
        let completionExpectation = expectation(description: "Success completion")
        
        urlSessionMock.enqueue(response: (data: expectedData, response: expectedSuccessResponse, error: nil))

        // When
        apiClient.execute(request: RequestMock()) { (result: Result<APIResponse<ParseErrorEntityMock>>) in
            // Then
            do {
                let _ = try result.get()
                XCTFail("Expected parse error to be thrown")
            } catch let error as ParseError {
                XCTAssertEqual(expectedSuccessResponse, error.httpURLResponse)
            } catch {
                XCTFail("Expected parse error to be thrown")
            }
            completionExpectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testResponseFailure() {
        let expectedResponse = "{\"key\":\"value\"}"
        let expectedData = expectedResponse.data(using: .utf8)
        let expectedFailureReponse = HTTPURLResponse(statusCode: 400)
        
        urlSessionMock.enqueue(response: (data: expectedData, response: expectedFailureReponse, error: nil))
        
        let completionExpectation = expectation(description: "Success completion")
        
        // When
        apiClient.execute(request: RequestMock()) { (result: Result<APIResponse<EntityMock>>) in
            // Then
            do {
                let _ = try result.get()
                XCTFail("Expected api error to be thrown")
            } catch let error as APIError {
//                XCTAssertTrue(expectedFailureReponse === error.httpURLResponse)
                XCTAssertEqual(expectedFailureReponse, error.httpURLResponse)
            } catch {
                XCTFail("Expected api error to be thrown")
            }
            
            completionExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
}

private extension APIRequestTests {
    private struct RequestMock: APIRequestCovenant {
        var urlRequest: URLRequest {
            return URLRequest(url: URL.testUrl)
        }
    }
    
    private struct EntityMock: Codable {
        var key: String
        
        var utf8String: String {
            let data = try? JSONEncoder().encode(self)
            return String(data: data!, encoding: .utf8)!
        }
    }
    
    private struct ParseErrorEntityMock: Decodable {
        init(from decoder: Decoder) throws {
            throw NSError(domain: "", code: 999, userInfo: nil)
        }
    }
}

