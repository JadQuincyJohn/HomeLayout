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
    var viewModelsByIndexPath: [IndexPath : AnyObject] = [:]

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
        let recycledOrNewViewModel = self.recycledOrNewViewModel(indexPath: indexPath)

        switch viewModel.model[indexPath.row] {
        case .list:
            (controller as! CollectionViewController).viewModel = recycledOrNewViewModel as? CollectionViewControllerViewModel
        case .text:
            (controller as! TextViewController).viewModel = recycledOrNewViewModel as? TextViewControllerViewModel
        case .images:
            (controller as! ImagesViewController).viewModel = recycledOrNewViewModel as? ImagesViewControllerViewModel
        }
        
        viewControllersByIndexPath[indexPath] = controller
        viewModelsByIndexPath[indexPath] = recycledOrNewViewModel
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
        imagesViewController.performFetchIfNeeded()
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
    
    func recycledOrNewViewModel(indexPath: IndexPath) -> AnyObject {
        
        if let existingViewModel = viewModelsByIndexPath[indexPath] {
            return existingViewModel
        }
        
        switch viewModel.model[indexPath.row] {
        case .list(let list):
            let viewModel = CollectionViewControllerViewModel(data: list)
            return viewModel
        case .text(let text):
            let viewModel = TextViewControllerViewModel(text: text)
            return viewModel
        case .images(let artist):
            let viewModel = ImagesViewControllerViewModel(artist: artist, service: service)
            return viewModel
        }
    }
    
    func recycledOrNewViewController(indexPath: IndexPath) -> UIViewController {
        
        let t = viewModel.model[indexPath.row]
        
        let elligibleController = unusedViewControllers.first {
            $0.isKind(of: t.className)
        }
        
        if let elligibleController = elligibleController {
            unusedViewControllers.remove(elligibleController)
            return elligibleController
        }
        
        switch t {
        case .text:
            let textViewController: TextViewController = add()
            return textViewController
        case .list:
            let collectionViewController: CollectionViewController = add()
            return collectionViewController
        case .images:
            let imagesviewController: ImagesViewController = add()
            return imagesviewController
        }
    }
    
    func add<T: UIViewController>() -> T {
        let controller = ViewController.storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
        addChildContentViewController(child: controller)
        return controller
    }
    
    func addChildContentViewController(child: UIViewController) {
        addChild(child)
        child.didMove(toParent: self)
    }
}
