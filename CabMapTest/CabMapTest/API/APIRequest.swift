import Foundation

enum RequestType: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}


typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?)  -> Void

protocol APIRequestCovenant {
    var urlRequest: URLRequest { get }
}

protocol APIClientCovenant {
    func execute<T>(request: APIRequestCovenant, completionHandler: @escaping (_ result: Result<APIResponse<T>>) -> Void)
}

// NOTE: - We can add more functions in following covenant as per our requirement.
protocol URLSessionCovenant {
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

extension URLSession: URLSessionCovenant {}

class APIClient: APIClientCovenant {
    private let constants = Constants()
    private let urlSession: URLSessionCovenant

    init(urlSessionConfiguration: URLSessionConfiguration, completionHandlerQueue: OperationQueue) {
        urlSession = URLSession(configuration: urlSessionConfiguration, delegate: nil, delegateQueue: completionHandlerQueue)
    }
    
    // NOTE: - Following constructor is used only for unit tests
    init(urlSession: URLSessionCovenant) {
        self.urlSession = urlSession
    }

    // MARK: - ApiClient

    func execute<T>(request: APIRequestCovenant, completionHandler: @escaping (Result<APIResponse<T>>) -> Void) {
        let dataTask = urlSession.dataTask(with: request.urlRequest) { [weak self] (data, response, error) in
            guard let httpURLResponse = response as? HTTPURLResponse,
                  let self = self else {
                completionHandler(.failure(NetworkRequestError(error: error)))
                return
            }

            if self.constants.statusCodeForSuccess == httpURLResponse.statusCode {
                do {
                    let response = try APIResponse<T>(data: data, httpURLResponse: httpURLResponse)
                    completionHandler(.success(response))
                } catch {
                    completionHandler(.failure(error))
                }
            } else {
                completionHandler(.failure(APIError(data: data, httpURLResponse: httpURLResponse)))
            }
        }
        dataTask.resume()
    }
}

// MARK: - Constants
private extension APIClient {
    struct Constants {
        let statusCodeForSuccess = 200
    }
}
