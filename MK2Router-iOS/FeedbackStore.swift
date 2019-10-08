//
//  FeedbackStore.swift
//  MK2Router
//
//  Created by k2o on 2016/11/25.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

open class FeedbackStore {
    public static let shared = FeedbackStore()
    
    // 帰還元VCごとのコンテキスト
    // キーを弱参照にすることで, VCの破棄とともに揮発する
    private var sourceToFeedbacks: NSMapTable<UIViewController, ContextHolder> = {
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
    
    open func store<SourceVC>(
        for sourceViewController: UIViewController,
        feedbackForSource: ((SourceVC) -> SourceVC.Feedback)
    ) where SourceVC: FeedbackType, SourceVC: UIViewController {
        guard let feedbackSourceViewController = sourceViewController as? SourceVC else {
            fatalError("Source view controller is not a type of FeedbackType.")
        }
        
        let feedback = feedbackForSource(feedbackSourceViewController)
        self.store(feedback: feedback, for: feedbackSourceViewController)
    }
    
    open func store<SourceVC>(
        feedback: SourceVC.Feedback,
        for sourceViewController: SourceVC
    ) where SourceVC: FeedbackType, SourceVC: UIViewController {
        self.sourceToFeedbacks.setObject(ContextHolder(body: feedback), forKey: sourceViewController)
    }
    
    open func feedback<SourceVC>(
        for sourceViewController: SourceVC
    ) -> SourceVC.Feedback? where SourceVC: FeedbackType, SourceVC: UIViewController {
        guard let feedbackHolder = self.sourceToFeedbacks.object(forKey: sourceViewController) else {
            return nil
        }
        
        return feedbackHolder.body as? SourceVC.Feedback
    }
}
