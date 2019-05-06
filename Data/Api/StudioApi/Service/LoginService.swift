//
//  LoginService.swift
//  Data
//
//  Created by Atsushi Miyake on 2019/05/05.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import Model

extension StudioApi {
    
    public final class LoginService: StudioApiService {
        
        fileprivate init() {}
        let provider = MoyaProvider<Endpoint>()
        
        enum Endpoint: StudioApiEndpoint {
            case login(name: String, password: String)
        }
    }
    public static let loginService = LoginService()
}

extension StudioApi.LoginService.Endpoint {
    
    var baseURL: URL {
        return URL(string: "https://www.supersaas.jp/schedule/login/gracenote/%E3%82%B7%E3%82%A7%E3%82%A2%E3%83%AA%E3%83%BC%E3%83%95%E8%A5%BF%E8%88%B9%E6%A9%8BGRACENOTE%E3%80%80%E3%82%B9%E3%82%BF%E3%82%B8%E3%82%AA%E4%BA%88%E7%B4%84")!
    }
    
    var path: String {
        switch self {
        case .login:
            return ""
        }
    }
    var method: Moya.Method {
        switch self {
        case .login: return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .login(name, password):
            let parameters: [String: Any] = [
                "name": name,
                "password": password
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}

extension StudioApi.LoginService {
    
    public func login(name: String, password: String) -> Observable<Void> {
        return self.provider.rx.request(.login(name: name, password: password))
            .asObservable()
            .flatMap { response -> Observable<Void> in
                switch response.statusCode {
                case 200..<300:
                    StudioApi.CookieStore.shared.store(httpUrlResponse: response.response!)
                case 300..<400:
                    print("redirection")
                case 400..<600:
                    print("error")
                default:
                    print("default")
                }
                return .just(())
        }
    }
}

