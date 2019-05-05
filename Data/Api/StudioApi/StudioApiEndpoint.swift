//
//  StudioApiEndpoint.swift
//  Data
//
//  Created by Atsushi Miyake on 2019/05/05.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import Moya

protocol StudioApiEndpoint: TargetType {}

extension StudioApiEndpoint {
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return [:]
    }
}
