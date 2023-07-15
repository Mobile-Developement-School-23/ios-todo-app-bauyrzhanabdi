import Alamofire
import Promises

// MARK: - NetworkClient

public protocol NetworkClient: AnyObject {
    func request<Parameters: Encodable, Response: Decodable>(
        baseURL: String?,
        _ relativePath: String,
        method: HTTPMethod,
        parameters: Parameters,
        headers: HTTPHeaders?
    ) -> Promise<Response>

    func upload<Response: Decodable>(
        _ relativePath: String,
        data: [String: Any]
    ) -> Promise<Response>
}

// MARK: - Convenience Methods

extension NetworkClient {
    public func get<Parameters: Encodable, Response: Decodable>(
        baseURL: String? = nil,
        _ relativePath: String,
        parameters: Parameters,
        headers: HTTPHeaders? = nil
    ) -> Promise<Response> {
        request(
            baseURL: baseURL,
            relativePath,
            method: .get,
            parameters: parameters,
            headers: headers
        )
    }

    public func post<Parameters: Encodable, Response: Decodable>(
        baseURL: String? = nil,
        _ relativePath: String,
        parameters: Parameters,
        headers: HTTPHeaders? = nil
    ) -> Promise<Response> {
        request(
            baseURL: baseURL,
            relativePath,
            method: .post,
            parameters: parameters,
            headers: headers
        )
    }

    public func put<Parameters: Encodable, Response: Decodable>(
        baseURL: String? = nil,
        _ relativePath: String,
        parameters: Parameters,
        headers: HTTPHeaders? = nil
    ) -> Promise<Response> {
        request(
            baseURL: baseURL,
            relativePath,
            method: .put,
            parameters: parameters,
            headers: headers
        )
    }

    public func patch<Parameters: Encodable, Response: Decodable>(
        baseURL: String? = nil,
        _ relativePath: String,
        parameters: Parameters,
        headers: HTTPHeaders? = nil
    ) -> Promise<Response> {
        request(
            baseURL: baseURL,
            relativePath,
            method: .patch,
            parameters: parameters,
            headers: headers
        )
    }

    public func delete<Parameters: Encodable, Response: Decodable>(
        baseURL: String? = nil,
        _ relativePath: String,
        parameters: Parameters,
        headers: HTTPHeaders? = nil
    ) -> Promise<Response> {
        request(
            baseURL: baseURL,
            relativePath,
            method: .delete,
            parameters: parameters,
            headers: headers
        )
    }
}

// MARK: - Convenience Methods With Empty Parameters

extension NetworkClient {
    public func get<Response: Decodable>(
        baseURL: String? = nil,
        _ relativePath: String,
        headers: HTTPHeaders? = nil
    ) -> Promise<Response> {
        request(
            baseURL: baseURL,
            relativePath,
            method: .get,
            parameters: Empty.value,
            headers: headers
        )
    }

    public func post<Response: Decodable>(
        baseURL: String? = nil,
        _ relativePath: String,
        headers: HTTPHeaders? = nil
    ) -> Promise<Response> {
        request(
            baseURL: baseURL,
            relativePath,
            method: .post,
            parameters: Empty.value,
            headers: headers
        )
    }

    public func delete<Response: Decodable>(
        baseURL: String? = nil,
        _ relativePath: String,
        headers: HTTPHeaders? = nil
    ) -> Promise<Response> {
        request(
            baseURL: baseURL,
            relativePath,
            method: .delete,
            parameters: Empty.value,
            headers: headers
        )
    }
}
