//
//  UIStoryboardSegue+Context.swift
//  MK2Router
//
//  Created by k2o on 2016/11/27.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

public extension MK2 where Base: UIStoryboardSegue {
    public func context<DestinationVC: UIViewController>(
        ifIdentifierEquals identifier: String,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    )
        where DestinationVC: DestinationType
    {
        if self.base.identifier != identifier {
            return
        }
        
        ContextStore.shared.store(
            for: self.base.destination,
            contextForDestination: contextForDestination
        )
    }
}
