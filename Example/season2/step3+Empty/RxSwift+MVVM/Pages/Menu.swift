//
//  Menu.swift
//  RxSwift+MVVM
//
//  Created by BH on 2022/07/14.
//  Copyright © 2022 iamchiwon. All rights reserved.
//

import Foundation

// View를 위한 Model -> ViewModel

struct Menu {
    var id: Int
    var name: String
    var price: Int
    var count: Int
}

extension Menu {
    static func fromMenuItems(id: Int, item: MenuItem) -> Menu {
        return Menu(id: id, name: item.name, price: item.price, count: 0)
    }
}
