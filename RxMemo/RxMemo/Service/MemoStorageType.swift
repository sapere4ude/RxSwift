//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by kant on 2023/03/31.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    @discardableResult // <- 결과값이 필요없을 수도 있으니 생성하는 것이라 해야하나..? 알아보긴 해야함
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>

    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
