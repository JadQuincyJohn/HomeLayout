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
    
    var unusedViewControllers: Set<UIViewController> = Set()
    var viewControllersByIndexPath: [IndexPath : UIViewController] = [:]
    
    let viewModel = ViewControllerViewModel()
    
    let service = APIService()
    
    static let storyboard = UIStoryboard(name: "Main", bundle: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
        setupTableView()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionContainerCell") as! CollectionContainerCell
        let controller = recycledOrNewViewController(indexPath: indexPath)
        
        switch viewModel.model[indexPath.row] {
        case .list(let list):
            (controller as! CollectionViewController).viewModel = CollectionViewControllerViewModel(data: list)
        case .text(let text):
            (controller as! TextViewController).viewModel = TextViewControllerViewModel(text: text)
        case .images(let artist):
            (controller as! ImagesViewController).viewModel = ImagesViewControllerViewModel(artist: artist, service: service)
        }
        
        viewControllersByIndexPath[indexPath] = controller
        cell.hostedView = controller.view
        cell.selectionStyle = .none
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch viewModel.model[indexPath.row] {
        case .text:
            return 60
        case .list:
            return 130
        case .images:
            return 200
        }
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let controller = viewControllersByIndexPath[indexPath] {
            viewControllersByIndexPath.removeValue(forKey: indexPath)
            unusedViewControllers.insert(controller)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let controller = viewControllersByIndexPath[indexPath]
        guard let imagesViewController = controller as? ImagesViewController else { return }
        imagesViewController.performFetch()
    }
}

private extension ViewController {
    
    func setupNavigationItem() {
        let label = UILabel()
        label.text = viewModel.title
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.shadowColor = UIColor(211, 84, 0)
        label.shadowOffset = CGSize(width: 1, height: 1)
        label.textColor = UIColor(241, 196, 15)
        
        navigationItem.titleView = label
    }
    
    func setupTableView() {
        tableView.register(CollectionContainerCell.self, forCellReuseIdentifier: String(describing: "CollectionContainerCell"))
        tableView.separatorStyle = .none
    }
    
    
    func addChildContentViewController(child: UIViewController) {
        addChild(child)
        child.didMove(toParent: self)
    }
    
    func recycledOrNewViewController(indexPath: IndexPath) -> UIViewController {
        
        let t = viewModel.model[indexPath.row]
        var cclass: AnyClass
        
        switch t {
        case .list:
            cclass = CollectionViewController.self
        case .text:
            cclass = TextViewController.self
        case .images:
            cclass = ImagesViewController.self
        }
        
        let elligibleController = unusedViewControllers.first {
            $0.isKind(of: cclass)
        }
        
        if let elligibleController = elligibleController {
            unusedViewControllers.remove(elligibleController)
            return elligibleController
        }
        
        switch t {
        case .text:
            let controller = ViewController.storyboard.instantiateViewController(withIdentifier: String(describing: TextViewController.self)) as! TextViewController
            addChildContentViewController(child: controller)
            return controller
        case .list:
            let controller = ViewController.storyboard.instantiateViewController(withIdentifier: String(describing: CollectionViewController.self)) as! CollectionViewController
            addChildContentViewController(child: controller)
            return controller
        case .images:
            let controller = ViewController.storyboard.instantiateViewController(withIdentifier: String(describing: ImagesViewController.self)) as! ImagesViewController
            addChildContentViewController(child: controller)
            return controller
        }
    }
}
