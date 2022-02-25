//
//  XCTestCase+Memory.swift
//  DataTests
//
//  Created by Luiz Hammerli on 24/02/22.
//

import XCTest

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line:  line)
        }
    }
}
