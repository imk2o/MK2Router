//
//  ExtensionProxy.swift
//  MK2Router
//
//  Created by k2o on 2016/11/04.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import Foundation

public struct MK2<Base: AnyObject> {
    public let base: Base
}

public extension NSObjectProtocol {
    var mk2: MK2<Self> {
        return MK2(base: self)
    }
}
