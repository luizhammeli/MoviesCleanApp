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

extension MainQueueDispatchDecorator: MovieLoader where T == MovieLoader {
    func load(completion: @escaping (MovieLoader.Result) -> Void) {
        instance.load { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}

extension MainQueueDispatchDecorator: MovieImageDataLoader where T == MovieImageDataLoader {
    func loadFeedImageData(from url: URL, completion: @escaping (MovieImageDataLoader.Result) -> Void) {
        instance.loadFeedImageData(from: url) { [weak self] result in
            self?.dispatch {
                completion(result)
            }
        }
    }
}
