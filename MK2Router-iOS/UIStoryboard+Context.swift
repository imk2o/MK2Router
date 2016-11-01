//
//  UIStoryboard+Context.swift
//  MK2Router
//
//  Created by k2o on 2016/11/01.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

public extension UIStoryboard {
    public func instantiateViewController<DestinationVC>(
        withIdentifier identifier: String? = nil,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) -> UIViewController where DestinationVC: DestinationType, DestinationVC: UIViewController {
        let viewController: UIViewController?
        if let identifier = identifier {
            viewController = self.instantiateViewController(withIdentifier: identifier)
        } else {
            viewController = self.instantiateInitialViewController()
        }
        guard let destinationViewController = viewController else {
            fatalError("Failed to instantiate view controller.")
        }
        
        ContextStore.shared.store(
            for: destinationViewController,
            contextForDestination: contextForDestination
        )
        
        return destinationViewController
    }
}
