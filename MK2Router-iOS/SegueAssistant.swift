//
//  SegueAssistant.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// prepareForSegue の代行を行う.
public class SegueAssistant {
    public private(set) var segue: UIStoryboardSegue
    public private(set) var sender: AnyObject?
    
    public init(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.segue = segue
        self.sender = sender
    }
    
    public func prepareIfIdentifierEquals<DestinationVC where DestinationVC: DestinationType, DestinationVC: UIViewController>(
        identifier: String,
        @noescape contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) {
        if self.segue.identifier != identifier {
            return
        }
        
        let _destinationViewController: UIViewController?
        if let navigationController = self.segue.destinationViewController as? UINavigationController {
            _destinationViewController = navigationController.topViewController
        } else {
            _destinationViewController = self.segue.destinationViewController
        }
        
        guard let destinationViewController = _destinationViewController as? DestinationVC else {
            fatalError("Destination view controller is not a type of \(String(DestinationVC)).")
        }
        
        let context = contextForDestination(destinationViewController)
        Router.shared.store(context: context, for: destinationViewController)
    }
}
