//
//  Destination.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

protocol Destination: class
{
    associatedtype Context
    var context: Context? { get set }
}

