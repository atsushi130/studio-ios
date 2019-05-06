//
//  ReservationService.swift
//  Data
//
//  Created by Atsushi Miyake on 2019/05/05.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Moya
import RxMoya
import RxSwift
import RxCocoa
import Model

extension StudioApi {
    
    public final class ReservationService: StudioApiService {
        
        fileprivate init() {}
        let provider = MoyaProvider<Endpoint>()
        
        enum Endpoint: StudioApiEndpoint {
            case fetchReservations(month: Int, day: Int)
            case reserve(studioReservation: StudioReservation)
            case cancel(studioReservation: StudioReservation)
        }
    }
    public static let reservationService = ReservationService()
}

extension StudioApi.ReservationService.Endpoint {
    
    var baseURL: URL {
        let base = "https://www.supersaas.jp/schedule/gracenote/%e3%82%b7%e3%82%a7%e3%82%a2%e3%83%aa%e3%83%bc%e3%83%95%e8%a5%bf%e8%88%b9%e6%a9%8bgracenote%e3%80%80%e3%82%b9%e3%82%bf%e3%82%b8%e3%82%aa%e4%ba%88%e7%b4%84"
        switch self {
        case let .fetchReservations(month, day):
            return URL(string: base + "?view=week&day=\(day)&month=\(month)")!
        case let .reserve(studioReservation):
            return URL(string: base + "?view=week&day=\(studioReservation.day)&month=\(studioReservation.month)")!
        case let .cancel(studioReservation):
            return URL(string: base + "?view=week&day=\(studioReservation.day)&month=\(studioReservation.month)")!
        }
    }
    
    var path: String {
        return ""
    }
    var method: Moya.Method {
        switch self {
        case .fetchReservations:
            return .get
        case .reserve:
            return .post
        case .cancel:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case .fetchReservations:
            return .requestPlain
        case let .reserve(studioReservation):
            let parameters: [String: Any] = [
                "reservation[start_time]": studioReservation.start,
                "reservation[finish_time]": studioReservation.end,
                "reservation[resource_id]": studioReservation.studioType.rawValue
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case let .cancel(studioReservation):
            let parameters: [String: Any] = [
                "oldres[start_time]": studioReservation.start,
                "oldres[finish_time]": studioReservation.end,
                "oldres[resource_id]": studioReservation.studioType.rawValue,
                "oldres[id]": studioReservation.orderId!,
                "destroy": ""
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        }
    }
}

extension StudioApi.ReservationService {
    
    public func fetchReservations(month: Int, day: Int) -> Observable<[StudioReservation]> {
        return self.provider.rx.request(.fetchReservations(month: month, day: day))
            .asObservable()
            .flatMap { response -> Observable<[StudioReservation]> in
                switch response.statusCode {
                case 200..<300:
                    print("success")
                    let values = String(data: response.data, encoding: .utf8)!
                        .split(separator: "\n")
                        .map(String.init)
                        .filter { $0.contains("var app=") }
                    let studioReservations = StudioReservationFactory.shared.parse(responseStrings: values)
                    return .just(studioReservations)
                case 300..<400:
                    print("redirection")
                case 400..<600:
                    print("error")
                default:
                    print("default")
                }
                return .just([])
            }
    }
    
    public func reserve(studioReservation: StudioReservation) -> Observable<Void> {
        return self.provider.rx.request(.reserve(studioReservation: studioReservation))
            .asObservable()
            .flatMap { response -> Observable<Void> in
                switch response.statusCode {
                case 200..<300:
                    print("success")
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
    
    public func cancel(studioReservation: StudioReservation) -> Observable<Void> {
        return self.provider.rx.request(.cancel(studioReservation: studioReservation))
            .asObservable()
            .flatMap { response -> Observable<Void> in
                switch response.statusCode {
                case 200..<300:
                    print("success")
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
