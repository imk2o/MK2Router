//
//  SegueAssistant.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

// TODO: deprecated
// UIStoryboardSegue+Contextに移行します
open class SegueAssistant {
    open fileprivate(set) var segue: UIStoryboardSegue
    open fileprivate(set) var sender: Any?
    
    public init(segue: UIStoryboardSegue, sender: Any? = nil) {
        self.segue = segue
        self.sender = sender
    }
    
    open func prepareIfIdentifierEquals<DestinationVC>(
        _ identifier: String,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) where DestinationVC: DestinationType, DestinationVC: UIViewController {
        if self.segue.identifier != identifier {
            return
        }
        
        ContextStore.shared.store(
            for: self.segue.destination,
            contextForDestination: contextForDestination
        )
    }
}
