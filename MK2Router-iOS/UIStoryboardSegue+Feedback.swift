//
//  UIStoryboardSegue+Feedback.swift
//  MK2Router
//
//  Created by k2o on 2016/11/27.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

public extension MK2 where Base: UIStoryboardSegue {
    func feedback<SourceVC: UIViewController>(
        ifIdentifierEquals identifier: String,
        feedbackForSource: ((SourceVC) -> SourceVC.Feedback)
    )
        where SourceVC: FeedbackType
    {
        if self.base.identifier != identifier {
            return
        }
        
        FeedbackStore.shared.store(
            for: self.base.source,
            feedbackForSource: feedbackForSource
        )
    }
    
    func feedback<SourceVC: UIViewController>(from _: SourceVC.Type) -> SourceVC.Feedback?
        where SourceVC: FeedbackType
    {
        guard let feedbackSourceViewController = self.base.source as? SourceVC else {
            fatalError("Source view controller is not a type of FeedbackType.")
        }
        
        return FeedbackStore.shared.feedback(for: feedbackSourceViewController)
    }
}
