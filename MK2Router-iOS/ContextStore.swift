//
//  ContextStore.swift
//  MK2Router
//
//  Created by k2o on 2016/11/01.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

open class ContextStore {
    public static let shared = ContextStore()
    
    // 遷移先VCごとのコンテキスト
    // キーを弱参照にすることで, VCの破棄とともに揮発する
    private var destinationToContexts: NSMapTable<UIViewController, ContextHolder> = {
        return NSMapTable<UIViewController, ContextHolder>.weakToStrongObjects()
    }()
    
    // 構造体やタプルなどの値型に対応するためのホルダクラス
    private class ContextHolder {
        let body: Any
        
        init(body: Any) {
            self.body = body
        }
    }

    private init() {
    }

    open func store<DestinationVC>(
        for destinationViewController: UIViewController,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) where DestinationVC: DestinationType, DestinationVC: UIViewController {
        guard let destinationContentViewController = destinationViewController.contentViewController() as? DestinationVC else {
            fatalError("Destination view controller is not a type of DestinationType.")
        }

        let context = contextForDestination(destinationContentViewController)
        self.store(context: context, for: destinationContentViewController)
    }
    
    open func store<DestinationVC>(
        context: DestinationVC.Context,
        for destinationViewController: DestinationVC
    ) where DestinationVC: DestinationType, DestinationVC: UIViewController {
        self.destinationToContexts.setObject(ContextHolder(body: context), forKey: destinationViewController)
    }
    
    open func context<DestinationVC>(
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
