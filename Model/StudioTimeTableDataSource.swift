//
//  StudioTimeTableDataSource.swift
//  Model
//
//  Created by Atsushi Miyake on 2019/05/11.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import RxDataSources

public enum StudioTimeTableSectionModel {
    case section(items: [StudioTimeTableSectionItem])
}

public enum StudioTimeTableSectionItem {
    case item(item: StudioSchedule)
}

extension StudioTimeTableSectionModel: SectionModelType {
    
    public typealias Item = StudioTimeTableSectionItem
    
    public var items: [Item] {
        switch self {
        case let .section(items):
            return items
        }
    }
    
    public init(original: StudioTimeTableSectionModel, items: [Item]) {
        self = original
    }
}
