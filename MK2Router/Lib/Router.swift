//
//  Router.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class Router {
    static let shared: Router = Router()
    
    private init() {
    }

    func perform<DestinationVC where DestinationVC: Destination, DestinationVC: UIViewController>(
        sourceViewController: UIViewController,
        destinationViewController: UIViewController,
        @noescape contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) {

        guard let destinationContentViewController = destinationViewController.contentViewController() as? DestinationVC else {
            return		// TODO
        }
        
        let context = contextForDestination(destinationContentViewController)
        destinationContentViewController.context = context
        
        if destinationViewController is UINavigationController {
            // モーダル遷移
            sourceViewController.presentViewController(destinationViewController, animated: true, completion: nil)
        } else {
            // プッシュ遷移
            sourceViewController.navigationController?.pushViewController(destinationViewController, animated: true)
        }
    }
    
    func perform<DestinationVC where DestinationVC: Destination, DestinationVC: UIViewController>(
        sourceViewController: UIViewController,
        storyboardName: String,
        storyboardID: String? = nil,
        @noescape contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController: UIViewController?
        if let storyboardID = storyboardID {
            viewController = storyboard.instantiateViewControllerWithIdentifier(storyboardID)
        } else {
            viewController = storyboard.instantiateInitialViewController()
        }
        guard let destinationViewController = viewController else {
            return
        }
        
        return self.perform(
            sourceViewController,
            destinationViewController: destinationViewController,
            contextForDestination: contextForDestination
        )
    }

    // コンテキスト渡しが不要な遷移
    func perform(
        sourceViewController: UIViewController,
        storyboardName: String,
        storyboardID: String? = nil
    ) {
        return self.perform(sourceViewController, storyboardName: storyboardName, storyboardID: storyboardID)
    }
}

private extension UIViewController {
    func contentViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            return navigationController.topViewController
        } else {
            return self
        }
    }
}
