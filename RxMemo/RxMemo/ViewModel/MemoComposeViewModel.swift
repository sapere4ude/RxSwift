//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by kant on 2023/03/31.
//

import Foundation
import RxSwift
import RxCocoa
import Action

// Compose scene 에서는 저장과 취소에 대한 구현을 진행
class MemoComposeViewModel: CommonViewModel {
    private let content: String?
    
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: "")
    }
    
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    // viewModel에서 직접 구현하면 처리방식이 하나로 고정이 되는 단점이 존재
    // 파라미터를 통해 전달 받으면 처리 방식을 동적으로 결정할 수 있다는 장점이 있다.
    
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        
        self.content = content
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
                action.execute(input)
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
