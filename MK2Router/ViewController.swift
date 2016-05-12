//
//  ViewController.swift
//  MK2Router
//
//  Created by k2o on 2016/05/12.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let assistant = SegueAssistant(segue: segue, sender: sender)
        
        assistant.prepareIfIdentifierEquals("ModalText") { (destination: TextViewController) -> String in
            return "Transit from Root View"
        }
    }
}
