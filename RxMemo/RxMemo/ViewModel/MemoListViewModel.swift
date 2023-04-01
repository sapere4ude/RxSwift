//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by kant on 2023/03/31.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import RxDataSources
import UIKit

typealias MemoSectionModel = AnimatableSectionModel<Int, Memo>

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[MemoSectionModel]> {
        return storage.memoList()
    }
    
    let dataSource: RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
       let ds = RxTableViewSectionedAnimatedDataSource<MemoSectionModel>(configureCell: { (dataSource, tableView, indexPath, memo) -> UITableViewCell in
           
           let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
           cell.textLabel?.text = memo.content
           return cell
       })
        
        ds.canEditRowAtIndexPath = { _, _ in return true }
        
        return ds
    }()
    
    func makeCreateActon() -> CocoaAction {
        return CocoaAction { _ in
            
            return self.storage.createMemo(content: "")
                .flatMap { memo ->Observable<Void> in
                     
                    // TODO: 여기부터 해결하기. 13강 6분10초
                    let composeViewModel = MemoComposeViewModel(title: "새 메모",
                                                                sceneCoordinator: self.sceneCoordinator,
                                                                storage: self.storage,
                                                                saveAction: self.performUpdate(memo: memo),
                                                                cancelAction: self.performCancel(memo: memo))
                    
                    let composeScene = Scene.compose(composeViewModel)
                    
                    return self.sceneCoordinator.transition(to: composeScene, style: .modal, animated: true).asObservable().map { _ in }
                    
                }
        }
    }
    
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            return self.storage.update(memo: memo, content: input).map { _ in }
        }
    }
    
    func performCancel(memo: Memo) -> CocoaAction {
        return Action {
            return self.storage.delete(memo: memo).map { _ in }
        }
    }
    
    lazy var detailAction: Action<Memo, Void> = {
       
        return Action { memo in
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, style: .push, animated: true).asObservable().map { _ in }
        }
    }()
    
    lazy var deleteAction: Action<Memo, Void> = {
        
        return Action { memo in
            return self.storage.delete(memo: memo)
                .map { _ in }
        }
    }()
}
