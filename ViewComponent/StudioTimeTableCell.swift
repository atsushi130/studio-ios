//
//  StudioTimeTableCell.swift
//  ViewComponent
//
//  Created by Atsushi Miyake on 2019/05/12.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import UIKit
import Model
import Extension
import SwiftExtensions

@IBDesignable
public final class StudioTimeTableCell: UICollectionViewCell {
    
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var studioA: CircleLabelView!
    @IBOutlet weak var studioB: CircleLabelView!
    @IBOutlet weak var studioC: CircleLabelView!
    
    public var studioSchedule: StudioSchedule! {
        didSet {
            let startDate = self.studioSchedule.startDate
            let hour = NSString(format: "%02d", startDate.hour)
            let minute = NSString(format: "%02d", startDate.minute)
            self.startTimeLabel.text = "\(hour):\(minute)"
            let availables = self.studioSchedule.availables
            self.studioA.alpha = availables.studioA ? 1 : 0.25
            self.studioB.alpha = availables.studioB ? 1 : 0.25
            self.studioC.alpha = availables.studioC ? 1 : 0.25
        }
    }
}
