//
//  ItemPageContainerViewController.swift
//  MK2Router
//
//  Created by k2o on 2016/11/01.
//  Copyright © 2016年 Yuichi Kobayashi. All rights reserved.
//

import UIKit
import MK2Router

// NOTE:
// Storyboardが以下のように構成されているものとする
// * PageContainerViewControllerのContainer ViewにUIPageViewControllerが実装され、pageViewControllerセグエで結ばれている
// * PageContainerViewControllerにPageViewDataSourceオブジェクトが実装され、pageViewDataSourceとしてアウトレットされている
class ItemPageContainerViewController: UIViewController {
    fileprivate var pageViewDataSource: PageViewDataSource!
    fileprivate var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageViewDataSource = PageViewDataSource()
        self.pageViewController.dataSource = self.pageViewDataSource
        self.pageViewController.delegate = self
        
        // NOTE: Under Top BarsがONのとき、最初のページ表示直後に適用されない問題があるため
        DispatchQueue.main.async {
            let firstViewController = self.pageViewDataSource.firstViewController()
            self.pageViewController.setViewControllers([firstViewController], direction: .forward, animated: false, completion: nil)
      
            self.navigationItem.title = firstViewController.title
        }
        
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: ">>", style: .plain, target: self, action: #selector(toLastPage)),
            UIBarButtonItem(title: "<<", style: .plain, target: self, action: #selector(toFirstPage))
        ]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if case .some("pageViewController") = segue.identifier {
            guard let pageViewController = segue.destination as? UIPageViewController else {
                fatalError()
            }
            
            self.pageViewController = pageViewController
        }
    }
    
    func toFirstPage(sender: AnyObject) {
        let firstViewController = self.pageViewDataSource.firstViewController()
        self.pageViewController.setViewControllers([firstViewController], direction: .reverse, animated: true, completion: nil)
    }
    
    func toLastPage(sender: AnyObject) {
        let lastViewController = self.pageViewDataSource.lastViewController()
        self.pageViewController.setViewControllers([lastViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension ItemPageContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // NOTE: self.viewControllers?.firstが現在のページに対応するVC
        self.navigationItem.title = self.pageViewController.viewControllers?.first?.title
    }
}

class PageViewDataSource: NSObject, UIPageViewControllerDataSource {
    let numberOfPages: Int = 10
    
    func firstViewController() -> UIViewController {
        return self.viewController(at: 0)
    }
    
    func lastViewController() -> UIViewController {
        return self.viewController(at: self.numberOfPages - 1)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
        ) -> UIViewController? {
        let index = self.indexOf(viewController)
        if index == 0 {
            return nil
            // Infinite loop
            //return self.viewController(at: self.numberOfPages - 1)
        }
        
        return self.viewController(at: index - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let index = self.indexOf(viewController)
        if index == self.numberOfPages - 1 {
            return nil
            // Infinite loop
            //return self.viewController(at: 0)
        }
        
        return self.viewController(at: index + 1)
    }
    
    private func viewController(at index: Int) -> UIViewController {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ItemDetailView") as? ItemDetailViewController else {
//            fatalError()
//        }
//        viewController.pageIndex = index
//        
//        Router.shared.store(context: index + 1, for: viewController)

//        let viewController = Router.shared.instantiateViewController(
//            storyboardName: "Main",
//            storyboardID: "ItemDetailView"
//        ) { (destination: ItemDetailViewController) in
//            destination.pageIndex = index		// FIXME
//            return index + 1
//        }

        return UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "ItemDetailView") { (destination: ItemDetailViewController) in
                destination.pageIndex = index		// FIXME
                return index + 1
        }
    }
    
    private func indexOf(_ viewController: UIViewController) -> Int {
        guard let viewController = viewController as? ItemDetailViewController else {
            fatalError()
        }
        
        return viewController.pageIndex
    }
}

//class ContentViewController: UIViewController {
//    var pageIndex: Int!
//
//    private var pageNumber: Int {
//        return self.pageIndex + 1
//    }
//
//    @IBOutlet weak var label: UILabel!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let title = "Page\(self.pageNumber)"
//        self.title = title
//        self.label.text = title
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//}
