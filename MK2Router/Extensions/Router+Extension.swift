//
//  Router+Extension.swift
//  MK2Router
//
//  Created by k2o on 2016/05/15.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

// MARK: - アプリ固有のルート
extension Router {
    enum Route {
        case ContactForm(Int)		// 問い合わせ画面(アイテムID)
        case ModalItemDetail(Int)	// 詳細画面(アイテムID)
    }
    
    func perform(
        route: Route,
        sourceViewController: UIViewController
    ) {
        switch route {
        case .ContactForm(let itemID):
            self.perform(sourceViewController, storyboardName: "Misc", storyboardID: "ContactFormNav") { (destination: ContactFormViewController) -> Int in
                return itemID
            }
        case .ModalItemDetail(let itemID):
            self.perform(sourceViewController, storyboardName: "Main", storyboardID: "ItemDetailNav") { (destination: ItemDetailViewController) -> Int in
                return itemID
            }
        }
    }
}

// MARK: - Router拡張を簡単に利用するユーティリティ.
extension UIViewController {
    /**
     指定のルートで画面遷移.
     
     - parameter route: ルート.
     */
    func performRoute(route: Router.Route) {
        Router.shared.perform(route, sourceViewController: self)
    }

    static func topmostViewController() -> UIViewController? {
        let rootViewController = UIApplication.sharedApplication().delegate?.window??.rootViewController
        
        return rootViewController?.topmostViewController()
    }
    
    private func topmostViewController() -> UIViewController? {
        if let navigationController = self as? UINavigationController {
            if let frontViewController = navigationController.viewControllers.last {
                return frontViewController.topmostViewController()
            } else {
                return self
            }
        } else {
            if let presentedViewController = self.presentedViewController {
                return presentedViewController.topmostViewController()
            } else {
                return self
            }
        }
    }
}
