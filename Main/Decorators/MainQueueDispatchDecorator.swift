//
//  MainQueueDispatchDecorator.swift
//  Main
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation
import Domain

final class MainQueueDispatchDecorator<T> {
    let instance: T
    
    init(instance: T) {
        self.instance = instance
    }
    
    private func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else { return DispatchQueue.main.async(execute: completion) }
        completion()
    }
}
