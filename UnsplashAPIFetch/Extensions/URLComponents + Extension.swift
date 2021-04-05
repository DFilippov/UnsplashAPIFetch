//
//  URLComponents + Extension.swift
//  UnsplashAPIFetch
//
//  Created by Ayu Filippova on 25/11/2019.
//  Copyright © 2019 Dmitry Filippov. All rights reserved.
//

import Foundation

extension URLComponents {
    
    mutating func setQueries(with queries: [String: String]) {
        self.queryItems = queries.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
    }
}
