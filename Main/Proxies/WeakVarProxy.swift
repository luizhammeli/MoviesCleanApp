//
//  WeakVarProxy.swift
//  Main
//
//  Created by Luiz Hammerli on 26/02/22.
//

import Foundation
import Presentation

final class WeakVarProxy<T: AnyObject> {
    private weak var instance: T?
    
    init(_ instance: T) {
        self.instance = instance
    }
}
