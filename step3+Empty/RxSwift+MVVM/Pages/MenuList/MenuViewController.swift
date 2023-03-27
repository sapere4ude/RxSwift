//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    
    let viewModel = MenuListViewModel()
    var disposeBag = DisposeBag()
    
    let cellId = "MenuItemTableViewCell"

    override func viewDidLoad() {
        super.viewDidLoad()

        // 한번만 subscribe 하면 지속적으로 사용이 가능하다!
        // 이와 같은 각각의 덩어리들을 Stream 으로 보면 된다
        
        // 일반적으로 만들어줄때의 모습
//        viewModel.itemCount
//            .map { "\($0)"}
//            .subscribe(onNext: { [weak self] in
//                self?.itemCountLabel.text = $0
//            })
//            .disposed(by: disposeBag)
        
//        viewModel.totalPrice
//            .map { $0.currencyKR() }
//            .subscribe(onNext: {
//                self.totalPrice.text = $0
//            })
//            .disposed(by: disposeBag)
        
        // RxCocoa 를 적용했을때
        // bind 를 사용하면 순환참조 없이 사용이 가능하다
        viewModel.itemCount
            .map { "\($0)"}
            .observeOn(MainScheduler.instance)
            .bind(to: itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.totalPrice
            .map { $0.currencyKR() }
            .observeOn(MainScheduler.instance)
            .bind(to: totalPrice.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.menuObservable
            .observeOn(MainScheduler.instance)
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)) { index, item, cell in
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self] increase in
                    self?.viewModel.changeCount(item, increase)
                }
            }
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }

    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
        //performSegue(withIdentifier: "OrderViewController", sender: nil)
        //viewModel.totalPrice.onNext(100)
        
        // menuObservable 이라는 제일 큰 물줄기를 변경하게 되는건데
        // 이렇게 되면 보여지는 tableView, count, price 값이 전부 변경되는 걸 확인할 수 있음
        viewModel.menuObservable.onNext([
            Menu(name: "changed", price: Int.random(in: 100...1000), count: Int.random(in: 0...3)),
            Menu(name: "changed", price: Int.random(in: 100...1000), count: Int.random(in: 0...3)),
            Menu(name: "changed", price: Int.random(in: 100...1000), count: Int.random(in: 0...3))
        ])
    }
}

// RxCocoa 를 사용하기 때문에 필요 없어지는 코드
//extension MenuViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menus.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        let menu = viewModel.menus[indexPath.row]
//
//
//        return cell
//    }
//}
