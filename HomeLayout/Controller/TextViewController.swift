//
//  TextViewController.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 04/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import UIKit

struct TextViewControllerViewModel {
    let text: String
}

class TextViewController: UIViewController {
    
    var viewModel: TextViewControllerViewModel! {
        didSet {
            DispatchQueue.main.async {
                self.updateUI()
            }
        }
    }
    
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private func updateUI() {
        label.text = viewModel.text
        label.textColor = UIColor(192, 57, 43)
    }
}
