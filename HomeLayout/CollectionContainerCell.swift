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
            if let hostedView = hostedView {
                self.contentView.embed(hostedView)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        hostedView?.removeFromSuperview()
        hostedView = nil
    }
}
