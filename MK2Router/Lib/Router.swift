//
//  Router.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

/// ルータ.
class Router {
    static let shared: Router = Router()
    
    private init() {
    }

    /**
     画面遷移を行う.
     遷移元のビューコントローラがNavigation Controller配下にあり、遷移先がNavigation Controllerでなければ
     プッシュ遷移、それ以外の場合はモーダル遷移を行う.
     
     - parameter sourceViewController:      遷移元ビューコントローラ.
     - parameter destinationViewController: 遷移先ビューコントローラ.
     - parameter contextForDestination:     遷移先へ渡すコンテキストを求めるブロック.
     */
    func perform<DestinationVC where DestinationVC: DestinationType, DestinationVC: UIViewController>(
        sourceViewController: UIViewController,
        destinationViewController: UIViewController,
        @noescape contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) {

        guard let destinationContentViewController = destinationViewController.contentViewController() as? DestinationVC else {
            fatalError("Destination view controller is not a type of \(String(DestinationVC)).")
        }
        
        let context = contextForDestination(destinationContentViewController)
        self.store(context: context, for: destinationContentViewController)
        
        if
            let sourceNavigationController = sourceViewController.navigationController
            where !(destinationViewController is UINavigationController)
        {
            // プッシュ遷移
            sourceNavigationController.pushViewController(destinationViewController, animated: true)
        } else {
            // モーダル遷移
            sourceViewController.presentViewController(destinationViewController, animated: true, completion: nil)
        }
    }

    /**
     画面遷移を行う.
     
     - parameter sourceViewController:  遷移元ビューコントローラ.
     - parameter storyboardName:        遷移先ストーリーボード名.
     - parameter storyboardID:          遷移先ストーリーボードID. nilの場合はInitial View Controllerが遷移先となる.
     - parameter contextForDestination: 遷移先へ渡すコンテキストを求めるブロック.
     */
    func perform<DestinationVC where DestinationVC: DestinationType, DestinationVC: UIViewController>(
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

    // MARK: - Manage view controller context

    // 遷移先VCごとのコンテキスト
    // キーを弱参照にすることで, VCの破棄とともに揮発する
    private var destinationToContexts: NSMapTable = {
        return NSMapTable.weakToStrongObjectsMapTable()
    }()
    
    /**
     遷移コンテキストを保存する.
     
     - parameter context:                   コンテキスト.
     - parameter destinationViewController: 遷移先ビューコントローラ.
     */
    func store<DestinationVC where DestinationVC: DestinationType, DestinationVC: UIViewController>(
        context context: DestinationVC.Context,
                for destinationViewController: DestinationVC
        ) {
        self.destinationToContexts.setObject(context as? AnyObject, forKey: destinationViewController)
    }
    
    /**
     ビューコントローラに対するコンテキストを求める.
     
     - parameter destinationViewController: 遷移先ビューコントローラ.
     
     - returns: コンテキストを返す.
     */
    func context<DestinationVC where DestinationVC: DestinationType, DestinationVC: UIViewController>(
        for destinationViewController: DestinationVC
        ) -> DestinationVC.Context? {
        return self.destinationToContexts.objectForKey(destinationViewController) as? DestinationVC.Context
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
