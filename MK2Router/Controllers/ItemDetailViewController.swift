//
//  ItemDetailViewController.swift
//  MK2Router
//
//  Created by k2o on 2016/05/14.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ItemDetailViewController: UIViewController, DestinationType {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if self.navigationController?.viewControllers.count == 1 {
            let dismissButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(dismiss))
            self.navigationItem.leftBarButtonItem = dismissButton
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.loadItem()
    }

    @IBAction func showContactForm(sender: UIButton) {
        guard let itemID = self.context else {
            return
        }

        // 指定のルートで問い合わせ画面へ
        self.performRoute(.ContactForm(itemID))
    }

    func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func loadItem() {
        let itemID = self.context
        
        ItemProvider.shared.getItemDetail(itemID) { (item) in
            self.imageView.image = item.image
            self.titleLabel.text = item.title
            self.detailTextView.text = item.detail
        }
    }
    
    // MARK: - Router DestinationType
    // この画面は、表示するアイテムIDをパラメータとして受け取る
    typealias Context = Int
    var context: Int!
}
