import Foundation

public extension URLSession {
    @available(iOS 13.0, *)
    func asyncDataTask(for request: URLRequest) async throws -> (Data, URLResponse) {
        let holder = DataTaskHolder()
        
        return try await withTaskCancellationHandler {
            return try await withCheckedThrowingContinuation { continuation in
                let dataTask = dataTask(with: request) { data, response, error in
                    guard !Task.isCancelled else {
                        return
                    }

                    if let error = error {
                        return continuation.resume(throwing: error)
                    }

                    guard
                        error == nil,
                        let data,
                        let response
                    else {
                        return continuation.resume(throwing: URLError(.notConnectedToInternet))
                    }

                    continuation.resume(returning: (data, response))
                }

                guard holder.store(dataTask) else {
                    return continuation.resume(throwing: CancellationError())
                }

                dataTask.resume()
            }
        } onCancel: {
            holder.cancel()
        }
    }
}


