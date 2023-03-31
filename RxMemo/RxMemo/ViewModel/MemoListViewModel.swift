//
//  MemoListViewModel.swift
//  RxMemo
//
//  Created by kant on 2023/03/31.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel: CommonViewModel {
    var memoList: Observable<[Memo]> {
        return storage.memoList()
    }
}
