//
//  UIStoryboard+Context.swift
//  MK2Router
//
//  Created by k2o on 2016/11/01.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

public extension MK2 where Base: UIStoryboard {
    
    /// ビューコントローラを生成し、コンテキストを渡す。
    ///
    /// - parameter identifier:            ビューコントローラID (nilの場合はInitial View Controllerを生成)
    /// - parameter contextForDestination: ビューコントローラへ綿足すコンテキストを求めるブロック
    ///
    /// - returns: ビューコントローラを返す。
    public func instantiateViewController<DestinationVC>(
        withIdentifier identifier: String? = nil,
        contextForDestination: ((DestinationVC) -> DestinationVC.Context)
    ) -> UIViewController where DestinationVC: DestinationType, DestinationVC: UIViewController {
        let viewController: UIViewController?
        if let identifier = identifier {
            viewController = self.base.instantiateViewController(withIdentifier: identifier)
        } else {
            viewController = self.base.instantiateInitialViewController()
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
