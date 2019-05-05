//
//  StudioApiService.swift
//  Data
//
//  Created by Atsushi Miyake on 2019/05/05.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Moya

protocol StudioApiService {
    associatedtype Endpoint: StudioApiEndpoint
    var provider: MoyaProvider<Endpoint> { get }
}
