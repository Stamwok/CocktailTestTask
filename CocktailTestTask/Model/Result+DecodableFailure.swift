//
//  Result+DecodableFailure.swift
//  CocktailTestTask
//
//  Created by  Егор Шуляк on 30.03.22.
//

import Foundation

extension Result: Decodable where Success: Decodable, Failure == DecodingError {
    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self = .success(try container.decode(Success.self))
        } catch let err as Failure {
            self = .failure(err)
        }
    }
}

extension Result {
    var value: Success? {
        if case let .success(value) = self {
            return value
        }
        return nil
    }
}
