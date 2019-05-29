//
//  parse.swift
//  morchequal
//
//  Created by Erik Jälevik on 29.05.19.
//  Copyright © 2019 Fileside. All rights reserved.
//

import Foundation

func parseJson(data: Data) -> Result<[String: Any], Error> {
    guard let dict = try?
        JSONSerialization.jsonObject(with: data) as? [String: Any]
    else {
        let response = String(data: data, encoding: .utf8)
        let msg = "Failed to parse response to JSON:\n" +
            "\(String(describing: response))"
        return .failure(GenericError.runtimeError(msg))
    }
    return .success(dict)
}
