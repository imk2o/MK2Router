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
    open static let shared: Router = Router()
    
    fileprivate init() {
    }

    /**
     画面遷移を行う.
     遷移元のビューコントローラがNavigation Controller配下にあり、遷移先がNavigation Controllerでなければ
     プッシュ遷移、それ以外の場合はモーダル遷移を行う.
     
     - parameter sourceViewController:      遷移元ビューコントローラ.
     - parameter destinationViewController: 遷移先ビューコントローラ.
     - parameter contextForDestination:     遷移先へ渡すコンテキストを求めるブロック.
     */
    open func perform<DestinationVC>(
        _ sourceViewController: UIViewController,
        destinationViewController: UIViewController,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) where DestinationVC: DestinationType, DestinationVC: UIViewController {

        ContextStore.shared.store(
            for: destinationViewController,
            contextForDestination: contextForDestination
        )
        
        self.perform(sourceViewController, destinationViewController: destinationViewController)
    }

    /**
     画面遷移を行う.
     
     - parameter sourceViewController:  遷移元ビューコントローラ.
     - parameter storyboardName:        遷移先ストーリーボード名.
     - parameter storyboardID:          遷移先ストーリーボードID. nilの場合はInitial View Controllerが遷移先となる.
     - parameter contextForDestination: 遷移先へ渡すコンテキストを求めるブロック.
     */
    open func perform<DestinationVC>(
        _ sourceViewController: UIViewController,
        storyboardName: String,
        storyboardID: String? = nil,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) where DestinationVC: DestinationType, DestinationVC: UIViewController {
        let destinationViewController = UIStoryboard(name: storyboardName, bundle: nil)
            .mk2
            .instantiateViewController(
                withIdentifier: storyboardID,
                contextForDestination: contextForDestination
        )
        
        return self.perform(sourceViewController, destinationViewController: destinationViewController)
    }
    
    func perform(
        _ sourceViewController: UIViewController,
        destinationViewController: UIViewController
    ) {
        if
            let sourceNavigationController = sourceViewController.navigationController
            , !(destinationViewController is UINavigationController)
        {
            // プッシュ遷移
            sourceNavigationController.pushViewController(destinationViewController, animated: true)
        } else {
            // モーダル遷移
            sourceViewController.present(destinationViewController, animated: true, completion: nil)
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
