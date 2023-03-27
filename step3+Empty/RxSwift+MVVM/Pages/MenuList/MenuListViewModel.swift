//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by Kant on 2023/03/27.
//  Copyright © 2023 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift

class MenuListViewModel {
    
//    var menus: [Menu] = [
//        Menu(name: "튀김1", price: 100, count: 0),
//        Menu(name: "튀김1", price: 100, count: 0),
//        Menu(name: "튀김1", price: 100, count: 0),
//        Menu(name: "튀김1", price: 100, count: 0)
//    ]
    
    //var itemsCount: Int = 5
    // Observable 의 역할은? 값을 넘겨주는 역할!
    //var totalPrice: Observable<Int> = Observable.just(10_000)
    
    // subject : Observable 밖에서 즉, 외부에서 값을 통제할 수 있는 역할
    //var totalPrice: PublishSubject<Int> = PublishSubject()
    
    //lazy var menuObservable = PublishSubject<[Menu]>() <- 이걸로 할땐 안됨. 그 이유를 꼭 알고 아래의 코드를 사용해야함
    lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        var menus: [Menu] = [
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김1", price: 100, count: 0),
            Menu(name: "튀김1", price: 100, count: 0)
        ]
        
        menuObservable.onNext(menus)
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    Menu(name: m.name, price: m.price, count: 0)
                }
            }
            .take(1) // 한번만 수행하고 끝나게 된다
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
    
    func changeCount(item: Menu, increase: Int) {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    Menu(name: m.name, price: m.price, count: 0)
                }
            }
            .take(1) // 한번만 수행하고 끝나게 된다
            .subscribe(onNext: {
                self.menuObservable.onNext($0)
            })
    }
}
