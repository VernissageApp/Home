//
//  https://mczachurski.dev
//  Copyright © 2023 Marcin Czachurski and the repository contributors.
//  Licensed under the Apache License 2.0.
//

import Foundation

public enum NetworkError: Error {
    case notSuccessResponse(URLResponse)
    case unknownError
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notSuccessResponse(let response):
            let statusCode = response.statusCode()

            return "It's error returned from remote server: '\(statusCode?.localizedDescription ?? "unknown")'. Request URL: '\(response.url?.absoluteString ?? "unknown")'."
        case .unknownError:
            return "Response doesn't contains any information about request status."
        }
    }
}
