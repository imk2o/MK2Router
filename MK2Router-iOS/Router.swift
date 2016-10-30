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

        guard let destinationContentViewController = destinationViewController.contentViewController() as? DestinationVC else {
            fatalError("Destination view controller is not a type of DestinationType.")
        }
        
        let context = contextForDestination(destinationContentViewController)
        self.store(context: context, for: destinationContentViewController)
        
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
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController: UIViewController?
        if let storyboardID = storyboardID {
            viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
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

    // MARK: - Manage view controller context

    // 遷移先VCごとのコンテキスト
    // キーを弱参照にすることで, VCの破棄とともに揮発する
    fileprivate var destinationToContexts: NSMapTable<UIViewController, ContextHolder> = {
        return NSMapTable<UIViewController, ContextHolder>.weakToStrongObjects()
    }()
    
    // 構造体やタプルなどの値型に対応するためのホルダクラス
    fileprivate class ContextHolder {
        let body: Any
        
        init(body: Any) {
            self.body = body
        }
    }
    
    /**
     遷移コンテキストを保存する.
     
     - parameter context:                   コンテキスト.
     - parameter destinationViewController: 遷移先ビューコントローラ.
     */
    func store<DestinationVC>(
        context: DestinationVC.Context,
                for destinationViewController: DestinationVC
        ) where DestinationVC: DestinationType, DestinationVC: UIViewController {
        
        self.destinationToContexts.setObject(ContextHolder(body: context), forKey: destinationViewController)
    }
    
    /**
     ビューコントローラに対するコンテキストを求める.
     
     - parameter destinationViewController: 遷移先ビューコントローラ.
     
     - returns: コンテキストを返す.
     */
    func context<DestinationVC>(
        for destinationViewController: DestinationVC
        ) -> DestinationVC.Context? where DestinationVC: DestinationType, DestinationVC: UIViewController {
        guard let contextHolder = self.destinationToContexts.object(forKey: destinationViewController) else {
            return nil
        }

        return contextHolder.body as? DestinationVC.Context
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
