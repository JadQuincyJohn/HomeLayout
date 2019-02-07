//
//  CollectionContainerCell.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 04/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import UIKit

class CollectionContainerCell: UITableViewCell {
    
    var hostedView: UIView? {
        didSet {
            guard let hostedView = hostedView else { return }
            contentView.embed(hostedView)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if hostedView?.superview == contentView { //Make sure that hostedView hasn't been added as a subview to a different cell
            hostedView?.removeFromSuperview()
        }
        hostedView = nil
    }
}



