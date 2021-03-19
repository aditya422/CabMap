import Foundation

struct NetworkRequestError: Error {
    let error: Error?

    var localizedDescription: String {
        error?.localizedDescription ?? Constants().defaultLocalizedDescription
    }

    private struct Constants {
        let defaultLocalizedDescription = "Network request error"
    }
}

struct APIError: Error {
    let data: Data?
    let httpURLResponse: HTTPURLResponse
}

struct ParseError: Error {
    static let code = 999

    let error: Error
    let httpURLResponse: HTTPURLResponse
    let data: Data?

    var localizedDescription: String {
        error.localizedDescription
    }
}

struct NetworkConnectionError: Error {
    var localizedDescription: String {
        Constants().defaultLocalizedDescription
    }
    
    private struct Constants {
        let defaultLocalizedDescription = "You are not connected to internet."
    }
}

struct APIResponse<T: Decodable> {
    let entity: T
    let httpURLResponse: HTTPURLResponse
    let data: Data?

    init(data: Data?, httpURLResponse: HTTPURLResponse) throws {
        do {
            self.entity = try JSONDecoder().decode(T.self, from: data ?? Data())
            self.httpURLResponse = httpURLResponse
            self.data = data
        } catch {
            throw ParseError(error: error, httpURLResponse: httpURLResponse, data: data)
        }
    }
}
