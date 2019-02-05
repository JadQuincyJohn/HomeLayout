//
//  ViewController.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 04/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var contentViewControllers: [UIViewController] = []
    
    var unusedViewControllers: Set<UIViewController> = Set()
    var viewControllersByIndexPath: [IndexPath : UIViewController] = [:]
    
    let viewModel = ViewControllerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel()
        label.text = viewModel.title
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        
        navigationItem.titleView = label
        tableView.register(CollectionContainerCell.self, forCellReuseIdentifier: String(describing: "CollectionContainerCell"))
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: "NormalCell"))
    }
    
    private func addChildContentViewController(child: UIViewController) {
        addChild(child)
        child.didMove(toParent: self)
    }
    
    private func recycledOrNewViewController(indexPath: IndexPath) -> UIViewController {
        
        let t = viewModel.model[indexPath.row]
        var cclass: AnyClass? = nil
        
        switch t {
        case .list:
            cclass = CollectionViewController.self
        case .text:
            cclass = TextViewController.self
        }
    
        let elligibleController = unusedViewControllers.first {
            $0.isKind(of: cclass!)
        }
        
        if let elligibleController = elligibleController {
            unusedViewControllers.remove(elligibleController)
            return elligibleController
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        switch t {
        case .text:
            let controller = storyboard.instantiateViewController(withIdentifier: String(describing: TextViewController.self)) as! TextViewController
            addChildContentViewController(child: controller)
            return controller
        case .list:
            let controller = storyboard.instantiateViewController(withIdentifier: String(describing: CollectionViewController.self)) as! CollectionViewController
            addChildContentViewController(child: controller)
            return controller
        }
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = viewModel.model.count
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionContainerCell") as! CollectionContainerCell
        let controller = recycledOrNewViewController(indexPath: indexPath)
        
        let t = viewModel.model[indexPath.row]
        switch t {
        case .list(let list):
            (controller as! CollectionViewController).viewModel = CollectionViewControllerViewModel(data: list)
        case .text(let text):
            (controller as! TextViewController).viewModel = TextViewControllerViewModel(text: text)
        }
        
        viewControllersByIndexPath[indexPath] = controller
        cell.hostedView = controller.view
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch viewModel.model[indexPath.row] {
        case .text:
            return 60
        case .list:
            return 130
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let controller = viewControllersByIndexPath[indexPath] {
            viewControllersByIndexPath.removeValue(forKey: indexPath)
            unusedViewControllers.insert(controller)
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}
