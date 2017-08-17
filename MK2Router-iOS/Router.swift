//
//  Router.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// ルータ.
open class Router {
    public enum PerformBehavior {
        case automatic
        case push
        case modal
    }
    
    open static let shared: Router = Router()
    
    fileprivate init() {
    }

    /**
     画面遷移を行う.
     
     - parameter sourceViewController:      遷移元ビューコントローラ.
     - parameter destinationViewController: 遷移先ビューコントローラ.
     - parameter behavior:                  遷移方法(pushまたはmodal).
     - parameter contextForDestination:     遷移先へ渡すコンテキストを求めるブロック.
     */
    open func perform<DestinationVC>(
        _ sourceViewController: UIViewController,
        destinationViewController: UIViewController,
        behavior: PerformBehavior = .automatic,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) where DestinationVC: DestinationType, DestinationVC: UIViewController {

        ContextStore.shared.store(
            for: destinationViewController,
            contextForDestination: contextForDestination
        )
        
        self.perform(sourceViewController, destinationViewController: destinationViewController, behavior: behavior)
    }

    /**
     画面遷移を行う.
     
     - parameter sourceViewController:  遷移元ビューコントローラ.
     - parameter storyboardName:        遷移先ストーリーボード名.
     - parameter storyboardID:          遷移先ストーリーボードID. nilの場合はInitial View Controllerが遷移先となる.
     - parameter behavior:                  遷移方法(pushまたはmodal).
     - parameter contextForDestination: 遷移先へ渡すコンテキストを求めるブロック.
     */
    open func perform<DestinationVC>(
        _ sourceViewController: UIViewController,
        storyboardName: String,
        storyboardID: String? = nil,
        behavior: PerformBehavior = .automatic,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) where DestinationVC: DestinationType, DestinationVC: UIViewController {
        let destinationViewController = UIStoryboard(name: storyboardName, bundle: nil)
            .mk2
            .instantiateViewController(
                withIdentifier: storyboardID,
                contextForDestination: contextForDestination
        )
        
        return self.perform(sourceViewController, destinationViewController: destinationViewController, behavior: behavior)
    }
    
    func perform(
        _ sourceViewController: UIViewController,
        destinationViewController: UIViewController,
        behavior: PerformBehavior = .automatic
    ) {
        func performPush(_ sourceNavigationController: UINavigationController) {
            sourceNavigationController.pushViewController(destinationViewController, animated: true)
        }
        func performModal() {
            sourceViewController.present(destinationViewController, animated: true, completion: nil)
        }

        switch behavior {
        case .automatic:
            if
                let sourceNavigationController = sourceViewController.navigationController
                , !(destinationViewController is UINavigationController)
            {
                performPush(sourceNavigationController)
            } else {
                performModal()
            }
        case .push:
            guard
                let sourceNavigationController = sourceViewController.navigationController,
                !(destinationViewController is UINavigationController)
            else {
                fatalError("Source view controller is not a child of navigation controller.")
            }
            
            performPush(sourceNavigationController)
        case .modal:
            performModal()
        }
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
