//
//  QQLrcLabel.swift
//  QQ音乐
//
//  Created by LHB on 16/4/6.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQLrcLabel: UILabel {


    var progress: CGFloat = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        // Drawing code
        super.drawRect(rect)
        
        UIColor.greenColor().set()
        
        UIRectFillUsingBlendMode(CGRectMake(0, 0, rect.width * progress, rect.height), CGBlendMode.SourceIn)

    }


}
