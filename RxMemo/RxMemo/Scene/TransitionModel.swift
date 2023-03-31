//
//  TransitionModel.swift
//  RxMemo
//
//  Created by Kant on 2023/03/31.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError: Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
