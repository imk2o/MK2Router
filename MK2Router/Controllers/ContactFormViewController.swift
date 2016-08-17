//
//  ContactFormViewController.swift
//  MK2Router
//
//  Created by k2o on 2016/05/15.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import MK2Router

class ContactFormViewController: UIViewController, DestinationType {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.loadItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func cancel(sender: UIBarButtonItem) {
        self.close()
    }
    
    @IBAction func sendMessage(sender: UIBarButtonItem) {
        guard
            let itemID = self.context,
            let title = self.titleLabel.text,
            let detail = self.messageTextView.text
        else {
            return
        }
        
        let delay: NSTimeInterval = 5
        let message = Message(itemID: itemID, title: title, detail: detail)
        MessageProvider.shared.sendMessage(message, delay: delay) {
            let alert = UIAlertController(title: "", message: "メッセージを送信しました。\n(\(delay)秒後に通知されます)", preferredStyle: .Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (_) in
                self.close()
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
 
    private func close() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    private func loadItem() {
        guard let itemID = self.context else {
            return
        }
        
        ItemProvider.shared.getItemDetail(itemID) { (item) in
            self.titleLabel.text = item.title
            self.messageTextView.becomeFirstResponder()
        }
    }
    
    // MARK: - Router DestinationType
    // この画面は、表示するアイテムIDをパラメータとして受け取る
    typealias Context = Int
}
