//
//  ViewControllerViewModel.swift
//  HomeLayout
//
//  Created by Jad Abi-Abdallah on 04/02/2019.
//  Copyright © 2019 Jad Abi-Abdallah. All rights reserved.
//

import UIKit

enum ModelType {
    case list([Int])
    case text(String)
    case images(Int)
}

struct ViewControllerViewModel {
    
    let title = "Nesting UICollectionView in UITableView"
    
    let model: [ModelType] = [.text("Nombre pairs"),
                              .list([2,4,6,8,10]),
                              .text("Albums de Quasimoto"),
                              .images(4928),
                              .text("Nombre impairs"),
                              .list([1,3,5,7,9,11]),
                              .text("Fibonacci"),
                              .list([0,1,2,3,5,8,13,21]),
                              .text("Nombre premiers"),
                              .list([2,3,5,7,11,13,17,19,23,29]),
                              .text("Multiple de 5"),
                              .list([5,10,15,20,25,30,35,40,45,50, 55,60,65]),
                              .text("Multiple de 3"),
                              .list([3,6,9,12,15,18,21,24,27,30]),
                              .text("Multiple de 4"),
                              .list([4,8,12,16,20,24,28,32,40]),
                              .text("Albums de Mos Def"),
                              .images(4063),
                              .text("Multiple de 7"),
                              .list([7,14,21,28,35,42,49,56,63]),
                              .text("Multiple de 11"),
                              .list([11,22,33,44,55,66,77,88,99]),
                              .text("Multiple de 10"),
                              .list([10,20,30,40,50,60]),
                              .text("Albums de Madlib"),
                              .images(4283),
                              .text("Nombre pairs"),
                              .list([2,4,6,8,10]),
                              .text("Nombre impairs"),
                              .list([1,3,5,7,9,11]),
                              .text("Fibonacci"),
                              .list([0,1,2,3,5,8,13,21]),
                              .text("Nombre premiers"),
                              .list([2,3,5,7,11,13,17,19,23,29]),
                              .text("Albums de J.Dilla"),
                              .images(4064),
                              .text("Albums de J.Rocc"),
                              .images(494972),
                              .text("Albums de Beatles"),
                              .images(1),
                              ]
}
