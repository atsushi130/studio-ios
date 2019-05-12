//
//  CircleLabelView.swift
//  ViewComponent
//
//  Created by Atsushi Miyake on 2019/05/12.
//  Copyright © 2019 Atsushi Miyake. All rights reserved.
//

import UIKit
import SwiftExtensions

@IBDesignable
public final class CircleLabelView: UIView, NibDesignable {
    
    @IBOutlet public weak var label: UILabel!
    
    @IBInspectable
    public var color: UIColor? {
        get { return self.backgroundColor }
        set { self.backgroundColor = newValue }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat {
        get { return self.layer.cornerRadius }
        set { self.layer.cornerRadius = newValue }
    }
    
    @IBInspectable
    public var text: String? {
        get { return self.label.text }
        set { self.label.text = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.configureNib()
        self.configureCornerRadius()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.configureNib()
        self.configureCornerRadius()
    }
    
    func configureCornerRadius() {
        self.cornerRadius = self.bounds.size.height / 2
        self.clipsToBounds = true
    }
}
