//
//  Scene.swift
//  RxMemo
//
//  Created by Kant on 2023/03/31.
//

import UIKit

enum Scene {
    case list(MemoListViewModel) // 메모 목록
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    func instantiate(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else { fatalError() }
            
            guard var listVC = nav.viewControllers.first as? MemoListViewController else {
                fatalError()
            }
            
            // 앱 시작시 Large Title 모드로 제대로 동작하지 않는 오류가 있어 main Queue에 넣어줘야한다.
            DispatchQueue.main.async {
                listVC.bind(viewModel: memoListViewModel)
            }
            
            return nav
            
        case .detail(let memoDetailViewModel):
            
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else { fatalError() }
            
            DispatchQueue.main.async {
                detailVC.bind(viewModel: memoDetailViewModel)
            }

            return detailVC
            
        case .compose(let memoComposeViewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else { fatalError() }
            
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else {
                fatalError()
            }
            
            DispatchQueue.main.async {
                composeVC.bind(viewModel: memoComposeViewModel)
            }
            
            return nav
        }
    }
    
}
