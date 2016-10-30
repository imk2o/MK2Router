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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.loadItems()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // SegueAssistantを用いた画面遷移アシスト
        let assistant = SegueAssistant(segue: segue, sender: sender)

        // segue.identifierが"ShowDetail"の場合、
        // 遷移先のItemDetailViewControllerにInt型のパラメータを渡す
        assistant.prepareIfIdentifierEquals("ShowDetail") { (destination: ItemDetailViewController) -> Int in
            guard
                let indexPath = self.tableView.indexPathForSelectedRow,
                let selectedItem = self.items?[(indexPath as NSIndexPath).row]
            else {
                fatalError()
            }
        
            return selectedItem.ID
        }
    }

    @IBAction func showPreferences(_ sender: UIBarButtonItem) {
        self.performRoute(.preferences)
    }
    
    fileprivate var items: [Item]?
    
    fileprivate func loadItems() {
        ItemProvider.shared.getAllItems { (items) in
            self.items = items
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension ItemListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            let itemCell = cell as? ItemCell,
            let item = self.items?[(indexPath as NSIndexPath).row]
        else {
            fatalError()
        }
        
        itemCell.configure(item)
    }
}
