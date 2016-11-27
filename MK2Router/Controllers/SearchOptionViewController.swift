//
//  SearchOptionViewController.swift
//  MK2Router
//
//  Created by k2o on 2016/11/25.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import MK2Router

class SearchOptionViewController: UITableViewController {

    @IBOutlet weak var keywordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.keywordTextField.becomeFirstResponder()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // 入力された検索条件をフィードバック
        segue.mk2.feedback(ifIdentifierEquals: "FeedbackOption") { (source: SearchOptionViewController) in
            return self.keywordTextField.text ?? ""
        }
    }
    
    @IBAction func cancelButtonDidgtap(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension SearchOptionViewController: MK2Router.FeedbackType {
    typealias Feedback = String
}
