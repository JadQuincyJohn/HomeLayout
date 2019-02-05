//
//  APIError.swift
//  DeezerExercise
//
//  Created by Zedenem on 06/09/2018.
//  Copyright © 2018 Zedenem. All rights reserved.
//

import Foundation

enum APIError: Error {
    case malformedURLError
    case noResultsError
    case noAdditionalResultsError
    case serverError(message: String, statusCode: Int)
    case decodingError(message: String)
}

extension APIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .malformedURLError:
            return NSLocalizedString("URL cannot be formed", comment: "malformedURLError description")
        case .noResultsError:
            return NSLocalizedString("No results available", comment: "noResultsError description")
        case .noAdditionalResultsError:
            return NSLocalizedString("No additional results available", comment: "noAdditionalResultsError description")
        case .serverError(let message, _):
            return message
        case .decodingError (let message):
            return message
        }
    }
    
    var statusCode: Int {
        switch self {
        case .serverError(_, let statusCode):
            return statusCode
        default:
            return -1
        }
    }
}
