//
//  QQMusicModel.swift
//  QQ音乐
//
//  Created by LHB on 16/4/5.
//  Copyright © 2016年 LHB. All rights reserved.
//

import UIKit

class QQMusicModel: NSObject {

    var name: String?

    var filename: String?

    var lrcname: String?

    var singer: String?

    var singerIcon: String?

    var icon: String?

    override init() {
        super.init()
    }
    
    init(dic: [String: AnyObject]) {
        super.init()
        setValuesForKeysWithDictionary(dic)
    }
    
    
    override func setValue(value: AnyObject?, forUndefinedKey key: String) {
        
    }
    
    
}
