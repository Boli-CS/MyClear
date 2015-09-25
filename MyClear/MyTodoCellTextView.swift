//
//  MyTodoCellTextField.swift
//  MyClear
//
//  Created by boli on 2/1/15.
//  Copyright (c) 2015 boli. All rights reserved.
//

import UIKit

class MyTodoCellTextView: UITextView {

    var id : Int64 = 0
    
    let strikeThroughLayer: CALayer
    // A Boolean value that determines whether the label should have a strikethrough.
    var strikeThrough : Bool {
        didSet {
            strikeThroughLayer.hidden = !strikeThrough
            if strikeThrough {
                resizeStrikeThrough()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        strikeThroughLayer = CALayer()
        strikeThroughLayer.backgroundColor = UIColor.whiteColor().CGColor
        strikeThroughLayer.hidden = true
        strikeThrough = false
        
        super.init(coder: aDecoder)
        layer.addSublayer(strikeThroughLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        resizeStrikeThrough()
    }
    
    let kStrikeOutThickness: CGFloat = 2.0
    func resizeStrikeThrough() {
        //        let textSize = text!.sizeWithAttributes([NSFontAttributeName:font])
        let textSize  = (text! as NSString).sizeWithAttributes([NSFontAttributeName:font!])
        strikeThroughLayer.frame = CGRect(x: 0, y: bounds.size.height/2,
            width: textSize.width, height: kStrikeOutThickness)
    }
}
