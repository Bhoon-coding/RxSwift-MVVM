//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by BH on 2022/07/14.
//  Copyright © 2022 iamchiwon. All rights reserved.
//

import Foundation

class MenuListViewModel {
    
    let menus: [Menu] = [
        Menu(name: "튀김", price: 500, count: 0),
        Menu(name: "떡볶이", price: 2000, count: 0),
        Menu(name: "순대", price: 1000, count: 0),
        Menu(name: "오뎅", price: 500, count: 0)
    ]
    
}
