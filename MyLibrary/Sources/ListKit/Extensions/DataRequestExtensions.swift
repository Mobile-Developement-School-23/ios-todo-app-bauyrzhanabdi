import Alamofire
import Foundation
import Promises

// MARK: - DataRequest + toPromise

extension DataRequest {
    func toPromise<Response: Decodable>() -> Promise<Response> {
        Promise { fulfill, reject in
            self.responseDecodable(
                of: Response.self,
                queue: .global(qos: .userInitiated),
                decoder: JSONDecoder.default
            ) { dataResponse in
                switch dataResponse.result {
                case let .success(value):
                    fulfill(value)
                case let .failure(error):
                    reject(error)
                }
            }
        }
    }
}
