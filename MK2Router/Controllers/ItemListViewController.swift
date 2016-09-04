//
//  ItemListViewController.swift
//  MK2Router
//
//  Created by k2o on 2016/05/14.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import MK2Router

class ItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.loadItems()
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // SegueAssistantを用いた画面遷移アシスト
        let assistant = SegueAssistant(segue: segue, sender: sender)

        // segue.identifierが"ShowDetail"の場合、
        // 遷移先のItemDetailViewControllerにInt型のパラメータを渡す
        assistant.prepareIfIdentifierEquals("ShowDetail") { (destination: ItemDetailViewController) -> Int in
            guard
                let indexPath = self.tableView.indexPathForSelectedRow,
                let selectedItem = self.items?[indexPath.row]
            else {
                fatalError()
            }
        
            return selectedItem.ID
        }
    }

    @IBAction func showPreferences(sender: UIBarButtonItem) {
        self.performRoute(.Preferences)
    }
    
    private var items: [Item]?
    
    private func loadItems() {
        ItemProvider.shared.getAllItems { (items) in
            self.items = items
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        guard
            let itemCell = cell as? ItemCell,
            let item = self.items?[indexPath.row]
        else {
            fatalError()
        }
        
        itemCell.configure(item)
    }
}
