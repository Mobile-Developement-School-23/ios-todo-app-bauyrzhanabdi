import Alamofire
import Foundation
import Promises
import UIKit

// MARK: - Constants

private enum Constants {
    static let maxImageSize: Double = 2.5 * 1024 * 1024
}

// MARK: - NetworkClientImpl

final class NetworkClientImpl: NetworkClient {
    private var baseURL: String {
        "https://beta.mrdekk.ru/todobackend"
    }

    private let session: Session

    init(session: Session) {
        self.session = session
    }

    func request<Parameters: Encodable, Response: Decodable>(
        baseURL: String?,
        _ relativePath: String,
        method: HTTPMethod,
        parameters: Parameters,
        headers: HTTPHeaders?
    ) -> Promise<Response> {
        let request = session.request(
            (baseURL ?? self.baseURL) + relativePath,
            method: method,
            parameters: parameters,
            encoder: parameterEncoder(for: method),
            headers: headers
        )

        // TODO: - разобраться почему на вытаскивается NetworkError при validate
        return request
            .toPromise()
    }

    func upload<Response: Decodable>(_ relativePath: String, data: [String: Any]) -> Promise<Response> {
        let multipartFormData: (MultipartFormData) -> Void = { formData in
            data.forEach { key, value in
                switch value {
                case let value as Int:
                    guard let data = "\(value)".data(using: .utf8) else {
                        return
                    }

                    formData.append(data, withName: key)
                case let value as String:
                    guard let data = value.data(using: .utf8) else {
                        return
                    }

                    formData.append(data, withName: key)
                case let value as UIImage:
                    guard
                        let size = value.jpegData(compressionQuality: 1).flatMap({ Double($0.count) }),
                        let data = value.jpegData(
                            compressionQuality: min(1, Constants.maxImageSize / size)
                        )
                    else {
                        return
                    }

                    formData.append(
                        data,
                        withName: key,
                        fileName: "\(key).jpeg",
                        mimeType: "image/jpeg"
                    )
                default:
                    break
                }
            }
        }

        return session
            .upload(multipartFormData: multipartFormData, to: baseURL + relativePath)
            .toPromise()
    }

    private func parameterEncoder(for method: HTTPMethod) -> ParameterEncoder {
        switch method {
        case .get:
            return URLEncodedFormParameterEncoder(
                encoder: URLEncodedFormEncoder(
                    arrayEncoding: .noBrackets,
                    dateEncoding: .secondsSince1970,
                    keyEncoding: .convertToSnakeCase
                )
            )
        default:
            return JSONParameterEncoder(encoder: .default)
        }
    }
}
