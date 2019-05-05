//
//  CookieStore.swift
//  Shared
//
//  Created by Atsushi Miyake on 2019/05/05.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Foundation

public final class CookieStore {
    
    public static let shared = CookieStore()
    private init() {}
    
    @discardableResult
    public func store(httpUrlResponse: HTTPURLResponse) -> Bool {
        guard let responseHeaders = httpUrlResponse.allHeaderFields as? [String : String],
              let url = httpUrlResponse.url else { return false }
        HTTPCookie
            .cookies(withResponseHeaderFields: responseHeaders, for: url)
            .forEach(HTTPCookieStorage.shared.setCookie)
        return true
    }
}
