//
//  URLRequestExtension.swift
//  GoContactApp
//
//  Created by Tarang Kaneriya on 08/01/20.
//  Copyright © 2020 Tarang Kaneriya. All rights reserved.
//

import Foundation

public extension URLRequest {

/// Returns a cURL command for a request
/// - return A String object that contains cURL command or "" if an URL is not properly initalized.
    var cURL: String {

    guard
        let url = url,
        let httpMethod = httpMethod,
        url.absoluteString.utf8.count > 0
    else {
            return ""
    }

    var curlCommand = "*** API Hit ***\n"

    // URL
    curlCommand = curlCommand.appendingFormat("URL : '%@' \\\n", url.absoluteString)

    // Method if different from GET
    curlCommand = curlCommand.appendingFormat("Method : %@ \\\n", httpMethod)

    // Headers
    let allHeadersFields = allHTTPHeaderFields!
    let allHeadersKeys = Array(allHeadersFields.keys)
    let sortedHeadersKeys  = allHeadersKeys.sorted(by: <)
    for key in sortedHeadersKeys {
        curlCommand = curlCommand.appendingFormat("Headers : '%@: %@' \\\n", key, self.value(forHTTPHeaderField: key)!)
    }

    // HTTP body
    if let httpBody = httpBody, httpBody.count > 0 {
        let httpBodyString = String(data: httpBody, encoding: String.Encoding.utf8)!
        let escapedHttpBody = URLRequest.escapeAllSingleQuotes(httpBodyString)
        curlCommand = curlCommand.appendingFormat(" --data '%@' \\\n", escapedHttpBody)
    }

    return curlCommand
}

/// Escapes all single quotes for shell from a given string.
static func escapeAllSingleQuotes(_ value: String) -> String {
    return value.replacingOccurrences(of: "'", with: "'\\''")
}
}
