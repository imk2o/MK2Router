//
//  TextViewController.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class TextViewController: UIViewController, Destination {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let text = self.context {
            self.textView.text = text
        }
        
        if self.navigationController?.viewControllers.count == 1 {
            let dismissButton = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: #selector(dismiss))
            self.navigationItem.leftBarButtonItem = dismissButton
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismiss() {
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

    // MARK: - Destination
    
    typealias Context = String
    var context: String?
}
