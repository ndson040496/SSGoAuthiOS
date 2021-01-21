//
//  SSGoAuthNetworkError.swift
//  Okee
//
//  Created by Son Nguyen on 1/6/21.
//

import Foundation
import SSeoNetwork

public struct SSGoAuthNetworkError: SSNetworkError, Error {
    
    struct ResponseError: Decodable {
        let code: Int
        let message: String
    }

    public let httpCode: Int
    public let customCode: Int
    public let message: String
    
    public init(data: Data, response: URLResponse) {
        self.init(httpCode: (response as? HTTPURLResponse)?.statusCode ?? 0, data: data)
    }

    init(httpCode: Int, data: Data) {
        self.httpCode = httpCode
        do {
            let error = try JSONDecoder().decode(ResponseError.self, from: data)
            customCode = error.code
            message = error.message
        } catch {
            customCode = 0
            message = ""
        }
    }
}
