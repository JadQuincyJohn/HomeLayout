//
//  ViewControllerViewModel.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 04/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import Foundation

enum ModelType {
    case list([Int])
    case text(String)
}

struct ViewControllerViewModel {
    
    let title = "Nesting UICollectionView in UITableView"
    
    let model: [ModelType] = [.text("Nombre pairs"),
                              .list([2,4,6,8,10]),
                              .text("Nombre impairs"),
                              .list([1,3,5,7,9,11]),
                              .text("Fibonacci"),
                              .list([0,1,2,3,5,8,13,21]),
                              .text("Nombre premiers"),
                              .list([2,3,5,7,11,13,17,19,23,29]),
                              .text("Multiple de 5"),
                              .list([5,10,15,20,25,30,35,40,45,50, 55,60,65]),
                              
                              .text("Nombre pairs"),
                              .list([2,4,6,8,10]),
                              .text("Nombre impairs"),
                              .list([1,3,5,7,9,11]),
                              .text("Fibonacci"),
                              .list([0,1,2,3,5,8,13,21]),
                              .text("Nombre premiers"),
                              .list([2,3,5,7,11,13,17,19,23,29]),
                              .text("Multiple de 5"),
                              .list([5,10,15,20,25,30,35,40,45,50, 55,60,65]),
                              
                              .text("Nombre pairs"),
                              .list([2,4,6,8,10]),
                              .text("Nombre impairs"),
                              .list([1,3,5,7,9,11]),
                              .text("Fibonacci"),
                              .list([0,1,2,3,5,8,13,21]),
                              .text("Nombre premiers"),
                              .list([2,3,5,7,11,13,17,19,23,29]),
                              .text("Multiple de 5"),
                              .list([5,10,15,20,25,30,35,40,45,50, 55,60,65]),
                              ]
}
