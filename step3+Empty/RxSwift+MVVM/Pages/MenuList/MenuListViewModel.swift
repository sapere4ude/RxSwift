//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by Kant on 2023/03/27.
//  Copyright © 2023 iamchiwon. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay

// ViewModel 은 로직 처리를 담고 있음.
// 이것에 대한 Test Case 만 만들어주면 되기때문에 좀 더 효율적인 TC 를 구성할 수 있음
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
    //lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])
    lazy var menuObservable = BehaviorRelay<[Menu]>(value: []) // BehaviorRelay <- 스트림이 끊어지지 않게 하는 역할
    
    lazy var itemCount = menuObservable.map {
        $0.map { $0.count }.reduce(0, +)
    }
    
    lazy var totalPrice = menuObservable.map {
        $0.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
//        var menus: [Menu] = [
//            Menu(id: 0, name: "튀김1", price: 100, count: 0),
//            Menu(id: 1, name: "튀김1", price: 100, count: 0),
//            Menu(id: 2, name: "튀김1", price: 100, count: 0),
//            Menu(id: 3, name: "튀김1", price: 100, count: 0)
//        ]
//        menuObservable.onNext(menus)
        
        _ = APIService.fetchAllMenusRx()
            .map { data -> [MenuItem] in
                struct Response: Decodable {
                    let menus: [MenuItem]
                }
                
                let response = try! JSONDecoder().decode(Response.self, from: data)
                
                return response.menus
            }
            .map { menuItems -> [Menu] in
                var menus: [Menu] = []
                menuItems.enumerated().forEach { index, item in
                    let menu = Menu.fromMenuItems(id: index, item: item)
                    menus.append(menu)
                }
                return menus
            }
            .take(1)
            .bind(to: menuObservable)
    }
    
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    Menu(id: m.id,
                         name: m.name,
                         price: m.price,
                         count: 0)
                }
            }
            .take(1) // 한번만 수행하고 끝나게 된다
            .subscribe(onNext: {
                //self.menuObservable.onNext($0)
                self.menuObservable.accept($0) // BehaviorRelay를 사용하면 값을 무조건 받을 수 밖에 없다보니 accept 메서드를 사용해준다
            })
    }
    
    func changeCount(item: Menu, increase: Int) {
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    if m.id == item.id {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: max(m.count + increase, 0))
                    } else {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: m.count)
                    }
                }
            }
            .take(1) // 한번만 수행하고 끝나게 된다
            .subscribe(onNext: {
                //self.menuObservable.onNext($0)
                self.menuObservable.accept($0)
            })
    }
    
    func onOrder() {
        
    }
}
