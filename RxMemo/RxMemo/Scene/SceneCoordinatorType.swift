//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by Kant on 2023/03/31.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    @discardableResult
    func transition(to scene: Scene, style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
