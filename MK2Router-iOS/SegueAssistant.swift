//
//  SegueAssistant.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// prepareForSegue の代行を行う.
open class SegueAssistant {
    open fileprivate(set) var segue: UIStoryboardSegue
    open fileprivate(set) var sender: Any?
    
    public init(segue: UIStoryboardSegue, sender: Any?) {
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
        
        let _destinationViewController: UIViewController?
        if let navigationController = self.segue.destination as? UINavigationController {
            _destinationViewController = navigationController.topViewController
        } else {
            _destinationViewController = self.segue.destination
        }
        
        guard let destinationViewController = _destinationViewController as? DestinationVC else {
            fatalError("Destination view controller is not a type of DestinationType.")
        }
        
        let context = contextForDestination(destinationViewController)
        Router.shared.store(context: context, for: destinationViewController)
    }
}
